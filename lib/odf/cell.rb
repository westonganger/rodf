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

require 'rubygems'
require 'builder'

require 'odf/container'
require 'odf/paragraph'

module ODF
  class Cell < Container
    contains :paragraphs

    alias :p :paragraph

    def initialize(*args)
      value = args.first || ''
      opts = args.last.instance_of?(Hash) ? args.last : {}

      @url = opts[:url]
      @type = opts[:type] || :string
      unless value.instance_of?(Hash)
        if value.respond_to? :strftime
          @value = value.strftime("%Y-%m-%d")
        else
          @value = value.to_s.strip
        end
      end

      @elem_attrs = make_element_attributes(@type, @value, opts)
      @mutiply = (opts[:span] || 1).to_i

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
      (@mutiply - 1).times {text = markup.tag! 'table:table-cell'}
      text
    end

    def contains_url?
      !@url.nil? && !@url.empty?
    end

  private

    def contains_string?
      :string == @type && !@value.nil? && !@value.empty?
    end

    def make_element_attributes(type, value, opts)
      attrs = {}
      attrs['office:value-type'] = type if :string == type || !empty(value) || !opts[:formula].nil?
      attrs['office:date-value'] = value if :date == type && !empty(value)
      attrs['office:value'] = value if :float == type && !empty(value)
      attrs['table:formula'] = opts[:formula] unless opts[:formula].nil?
      attrs['table:style-name'] = opts[:style] unless opts[:style].nil?
      attrs['table:number-columns-spanned'] = opts[:span] unless opts[:span].nil?
      attrs['table:number-matrix-columns-spanned'] =
        attrs['table:number-matrix-rows-spanned'] = 1 if opts[:matrix_formula]
      attrs
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

    def empty(value)
      value.nil? || value.empty?
    end
  end
end

