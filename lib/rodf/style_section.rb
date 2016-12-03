# Copyright (c) 2010 Thiago Arrais
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

module RODF
  class StyleSection
    def initialize(type, second = {})
      @type = type
      if second.instance_of?(Hash)
        @elem_attrs = make_element_attributes(second)
      else
        @content, @elem_attrs = second, {}
      end
    end

    def xml
      Builder::XmlMarkup.new.number @type, @content, @elem_attrs
    end

    def make_element_attributes(opts)
      {'number:style' => opts[:style], 'number:textual' => opts[:textual]}
    end
  end
end

