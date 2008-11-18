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

require 'odf/cell'

describe ODF::Cell do
  it "should hold text content in a paragraph tag" do
    output = ODF::Cell.new('Test').xml
    output.should have_tag('//table:table-cell/*')
    output.should have_tag('//text:p')
    Hpricot(output).at('text:p').innerHTML.should == 'Test'
  end

  it "should have string as default value type" do
    [ODF::Cell.new('Test').xml, ODF::Cell.new(54).xml].each do |xml|
      Hpricot(xml).at('table:table-cell')['office:value-type'].should=='string'
    end
  end

  it "should allow value types to be specified" do
    output = ODF::Cell.new(34.2, :type => :float).xml
    Hpricot(output).at('table:table-cell')['office:value-type'].should=='float'
  end

  it "should place strings in a paragraph tag and floats in value attribute" do
    output = ODF::Cell.new('Test').xml
    Hpricot(output).at('text:p').innerHTML.should == 'Test'

    output = ODF::Cell.new(47, :type => :float).xml
    output.should_not have_tag('//table:table-cell/*')
    Hpricot(output).at('table:table-cell')['office:value'].should == '47'

    output = ODF::Cell.new(34.2, :type => :string).xml
    Hpricot(output).at('text:p').innerHTML.should == '34.2'
  end

  it "should accept formulas" do
    output = ODF::Cell.new(:type => :float,
                           :formula => "oooc:=SUM([.A1:.A4])").xml

    elem = Hpricot(output).at('table:table-cell')
    elem['office:value-type'].should == 'float'
    elem['table:formula'].should == 'oooc:=SUM([.A1:.A4])'
  end

  it "should not have an empty paragraph" do
    [ODF::Cell.new, ODF::Cell.new(''), ODF::Cell.new('  ')].each do |cell|
      cell.xml.should_not have_tag('text:p')
    end
  end

  it "should allow an style to be specified" do
    cell = ODF::Cell.new 45.8, :type => :float, :style => 'left-column-cell'
    Hpricot(cell.xml).at('table:table-cell')['table:style-name'].
      should == 'left-column-cell'
  end
end
