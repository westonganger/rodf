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
require 'odf/property'

module ODF
  class Style < Container
    contains :properties
    
    FAMILIES = {:cell => 'table-cell', :column => 'table-column'}

    def initialize(name='', opts={})
      @name = name
      @elem_attrs = make_element_attributes(@name, opts)
    end

    def xml
      Builder::XmlMarkup.new.style:style, @elem_attrs do |xml|
        xml << properties_xml
      end
    end

    def make_element_attributes(name, opts)
      attrs = {
        'style:name' => name,
        'style:family' => (FAMILIES[opts[:family]] || opts[:family])}
      attrs['style:data-style-name'] = opts[:data_style] unless opts[:data_style].nil?
      attrs['style:parent-style-name'] = opts[:parent].to_s unless opts[:parent].nil?
      attrs
    end

    def to_s
      @name
    end
  end 
end

