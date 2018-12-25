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

require_relative 'container'
require_relative 'cell'

module RODF
  class Row < Container
    contains :cells
    attr_reader :number
    attr_writer :style

    def initialize(number=0, opts={})
      @number = number
      @style = opts[:style]
    end

    def xml
      elem_attrs = {}
      elem_attrs['table:style-name'] = @style unless @style.nil?
      Builder::XmlMarkup.new.tag! 'table:table-row', elem_attrs do |xml|
        xml << cells_xml
      end
    end
  end
end

