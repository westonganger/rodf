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

module ODF
  class Cell
    def initialize(*args)
      value = args.first || ''
      opts = args.last.instance_of?(Hash) ? args.last : {}

      @type = opts[:type] || :string
      @value = value.to_s.strip unless value.instance_of? Hash

      @elem_attrs = make_element_attributes(@type, @value, opts)
    end

    def xml
      Builder::XmlMarkup.new.tag! 'table:table-cell', @elem_attrs do |xml|
        xml.text(:p, @value) if contains_string?
      end
    end

    def contains_string?
      :string == @type && !@value.nil? && !@value.empty?
    end

    def make_element_attributes(type, value, opts)
      attrs = {'office:value-type' => type}
      attrs['office:value'] = value unless contains_string?
      attrs['table:formula'] = opts[:formula] unless opts[:formula].nil?
      attrs['table:style-name'] = opts[:style] unless opts[:style].nil?
      attrs['table:number-matrix-columns-spanned'] =
        attrs['table:number-matrix-rows-spanned'] = 1 if opts[:matrix_formula]
      attrs
    end
  end
end

