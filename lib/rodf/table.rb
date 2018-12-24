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

require 'rodf/column'
require 'rodf/container'
require 'rodf/row'

module RODF
  class Table < Container
    contains :rows, :columns

    def initialize(title = nil)
      @title = title
      @last_row = 0
    end

    alias create_row row
    def row(options={}, &contents)
      create_row(next_row, options) {instance_eval(&contents) if block_given?}
    end

    def xml
      Builder::XmlMarkup.new.table:table, 'table:name' => @title do |xml|
        xml << columns_xml
        xml << rows_xml
      end
    end
  private
    def next_row
      @last_row += 1
    end
  end
end
