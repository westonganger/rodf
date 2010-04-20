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

require 'odf/paragraph'

module ODF
  class Cell
    def initialize(*args)
      value = args.first || ''
      opts = args.last.instance_of?(Hash) ? args.last : {}

      @url = opts[:url]
      @type = opts[:type] || :string
      unless value.instance_of?(Hash)
        if [Date, DateTime, Time].include? value.class
          @value = value.strftime("%Y-%m-%d")
        else
          @value = value.to_s.strip
        end
      end

      @elem_attrs = make_element_attributes(@type, @value, opts)
      @mutiply = (opts[:span] || 1).to_i

      make_value_paragraph
    end

    def paragraph(*args)
      @paragraph = Paragraph.new(*args)
      yield @paragraph if block_given?
    end

    def paragraph_xml
      return '' if @paragraph.nil?
      @paragraph.xml
    end

    def xml
      markup = Builder::XmlMarkup.new
      text = markup.tag! 'table:table-cell', @elem_attrs do |xml|
        xml << paragraph_xml
      end
      (@mutiply - 1).times {text = markup.tag! 'table:table-cell'}
      text
    end

    def contains_string?
      :string == @type && !@value.nil? && !@value.empty?
    end

    def contains_url?
      !@url.nil? && !@url.empty?
    end

    def make_element_attributes(type, value, opts)
      attrs = {'office:value-type' => type}
      attrs['office:date-value'] = value if :date == type
      attrs['office:value'] = value if :float == type
      attrs['table:formula'] = opts[:formula] unless opts[:formula].nil?
      attrs['table:style-name'] = opts[:style] unless opts[:style].nil?
      attrs['table:number-columns-spanned'] = opts[:span] unless opts[:span].nil?
      attrs['table:number-matrix-columns-spanned'] =
        attrs['table:number-matrix-rows-spanned'] = 1 if opts[:matrix_formula]
      attrs
    end

    def make_value_paragraph
      if contains_string?
        paragraph do |p|
          if contains_url?
            p.link @value, :href => @url
          else
            p << @value
          end
        end
      end
    end
  end
end

