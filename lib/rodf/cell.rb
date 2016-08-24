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

require 'builder'

require 'rodf/container'
require 'rodf/paragraph'

module RODF
  class Cell < Container
    contains :paragraphs

    alias :p :paragraph

    def initialize(value=nil, opts={})
      opts = {} unless opts.is_a?(Hash)

      @value = value
      @type = opts[:type]

      if value
        @url = opts[:url]

        if !@type
          if value.is_a?(Numeric)
            @type = :float
          elsif @value.respond_to?(:strftime)
            @type = :date
            if value.is_a?(Date)
              @value = value.strftime("%Y-%m-%d")
            else
              @value = value.strftime("%Y%m%dT%H%M%S")
            end
          else
            @type = :string
            @value = value.to_s
          end
        end
      end

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
      !@url.nil? && !@url.empty?
    end

  private

    def contains_string?
      :string == @type && !empty?(@value)
    end

    def make_element_attributes(type, value, opts)
      attrs = {}
      attrs['office:value-type'] = type if type == :string || !blank?(value) || !opts[:formula].nil?
      attrs['office:date-value'] = value if type == :date && !blank?(value)
      attrs['office:value'] = value if type == :float && !blank?(value)
      attrs['table:formula'] = opts[:formula] unless opts[:formula].nil?
      attrs['table:style-name'] = opts[:style] unless opts[:style].nil?
      attrs['table:number-columns-spanned'] = opts[:span] unless opts[:span].nil?
      attrs['table:number-matrix-columns-spanned'] =
        attrs['table:number-matrix-rows-spanned'] = 1 if opts[:matrix_formula]
      return attrs
    end

    def make_value_paragraph
      if contains_string?
        cell, value, url = self, @value, @url
        paragraph do
          if cell.contains_url?
            link value, :href => url
          else
            self << value
          end
        end
      end
    end

    def blank?(value)
      respond_to?(:empty?) ? value.empty? : value.nil?
    end
  end
end

