# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# rODF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with rODF.  If not, see <http://www.gnu.org/licenses/>.

require 'date'

require 'builder'

require_relative 'container'
require_relative 'paragraph'

module RODF
  class Cell < Container
    contains :paragraphs

    alias :p :paragraph

    def initialize(value=nil, opts={})
      if value.is_a?(Hash)
        opts = value
        value = ''
      else
        if value.is_a?(String)
          value = value.strip
        end
        opts = {} unless opts.is_a?(Hash)
      end

      @value = value || ''
      @type = opts[:type]

      unless empty?(@value)
        @url = opts[:url]

        if !@type
          if @value.is_a?(Numeric)
            @type = :float
          elsif @value.respond_to?(:strftime)
            ### for auto type inference force :date type because :time doesnt store any date info
            @type = :date
          else
            @type = :string
            @value = @value.to_s
          end
        end
      end

      ### TODO: set default DataStyle for the Spreadsheet for Date / Time / DateTime cells formatting

      @elem_attrs = make_element_attributes(@type, @value, opts)
      @multiplier = (opts[:span] || 1).to_i

      make_value_paragraph
    end

    def style=(style_name)
      @elem_attrs['table:style-name'] = style_name
    end

    def xml
      markup = Builder::XmlMarkup.new
      text = markup.tag! 'table:table-cell', @elem_attrs do |xml|
        xml << paragraphs_xml
      end
      (@multiplier - 1).times {text = markup.tag! 'table:table-cell'}
      text
    end

    def contains_url?
      !empty?(@url)
    end

  private

    def contains_string?
      :string == @type && !empty?(@value)
    end

    def make_element_attributes(type, value, opts)
      attrs = {}

      if !empty?(value) || !opts[:formula].nil? || type == :string
        attrs['office:value-type'] = type 
      end
      
      if type != :string && !empty?(value)
        case type
        when :date
          attrs['office:date-value'] = value
        when :time
          attrs['office:time-value'] = value
        else ### :float, :percentage, :currency
          attrs['office:value'] = value
        end
      end

      unless opts[:formula].nil?
        attrs['table:formula'] = opts[:formula]
      end

      unless opts[:style].nil?
        attrs['table:style-name'] = opts[:style]
      end

      unless opts[:span].nil?
        attrs['table:number-columns-spanned'] = opts[:span]
      end

      if opts[:matrix_formula] 
        attrs['table:number-matrix-columns-spanned'] = 1
        attrs['table:number-matrix-rows-spanned'] = 1 
      end

      return attrs
    end

    def make_value_paragraph
      if contains_string?
        cell, value, url = self, @value, @url

        # Split out newlines to be new cells since the text has been escaped at this point
        value.to_s.split("\n").each do |split_value|
          paragraph do
            if cell.contains_url?
              link split_value, href: url
            else
              self << split_value
            end
          end
        end
      end
    end

    def empty?(value)
      value.respond_to?(:empty?) ? value.empty? : value.nil?
      #respond_to?(:empty?) ? (value.empty? || value =~ /\A[[:space:]]*\z/) : value.nil?
    end

  end
end
