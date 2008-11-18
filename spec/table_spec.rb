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

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'odf/table'

describe ODF::Table do
  it "should allow rows to be added" do
    output = ODF::Table.create('Example') {|t| }
    output.should have_tag('//table:table')
    output.should_not have_tag('//table:table/*')

    output = ODF::Table.create('MyTable') {|t| t.row }
    output.should have_tag('//table:table/*', :count => 1)
    output.should have_tag('//table:table-row')

    output = ODF::Table.create('MyTable') {|t|
      t.row
      t.row
    }
    output.should have_tag('//table:table/*', :count => 2)
    output.should have_tag('//table:table-row')
  end

  it "should provide row numbers" do
    output = ODF::Table.create('Row letter table') {|t|
      t.row {|row| row.cell}
      t.row {|row| row.cell(row.number)}
    }
    output.should have_tag('text:p')
    Hpricot(output).at('text:p').innerHTML.should == '2'
  end
end
