# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# Foobar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

require 'rubygems'
require 'builder'

module ODF
  class Cell
    def initialize(*args)
      value = args.first || ''
      opts = args.last.instance_of?(Hash) ? args.last : {}

      @type = opts[:type] || :string
      @formula = opts[:formula]
      @style = opts[:style]
      @value = value.to_s.strip unless value.instance_of? Hash
    end

    def xml
      elem_attrs = {'office:value-type' => @type}
      elem_attrs['office:value'] = @value unless contains_string?
      elem_attrs['table:formula'] = @formula unless @formula.nil?
      elem_attrs['table:style-name'] = @style unless @style.nil?

      Builder::XmlMarkup.new.tag! 'table:table-cell', elem_attrs do |xml|
        xml.text(:p, @value) if contains_string?
      end
    end

    def contains_string?
      :string == @type && !@value.nil? && !@value.empty?
    end
  end
end

