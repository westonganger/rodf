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

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'odf/row'

describe ODF::Row do
  it "should allow cells to be added" do
    output = ODF::Row.create
    output.should have_tag('//table:table-row')
    output.should_not have_tag('//table:table-row/*')

    output = ODF::Row.create {|r|
      r.cell
      r.cell
    }
    output.should have_tag('//table:table-row/*', :count => 2)
    output.should have_tag('//table:table-cell')
  end

  it "should accept parameterless blocks" do
    output = ODF::Row.create do
      cell
      cell
    end
    output.should have_tag('//table:table-row/*', :count => 2)
    output.should have_tag('//table:table-cell')
  end
end
