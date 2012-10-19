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

require 'odf/spreadsheet'

describe ODF::SpreadSheet do
  it "should have the expected structure" do
    output = ODF::SpreadSheet.create {|s| }
    output.should have_tag('//office:document-content/*')
    output.should have_tag('//office:body/*')
    output.should have_tag('//office:spreadsheet')
  end

  it "should be empty if no tables were added" do
    output = ODF::SpreadSheet.create {|s| }
    output.should_not have_tag('//office:spreadsheet/*')
  end

  it "should include tables when asked to" do
    output = ODF::SpreadSheet.create { |s|
      s.table 'Example'
    }
    output.should have_tag('//office:spreadsheet/*', :count => 1)
    output.should have_tag('//table:table', :count => 1)
    Hpricot(output).at('//table:table')['table:name'].should == 'Example'

    output = ODF::SpreadSheet.create { |s|
      s.table 'First table'
      s.table 'Second table'
    }
    output.should have_tag('//office:spreadsheet/*', :count => 2)
  end

  it "should allow rows to be added inside tables" do
    output = ODF::SpreadSheet.create do |s|
      s.table('My table') do |t|
        t.row
      end
    end

    output.should have_tag('//table:table/*')
    output.should have_tag('//table:table-row')
  end

  it "should allow styles to be added" do
    ODF::SpreadSheet.create.should_not have_tag('//office:automatic-styles')
    output = ODF::SpreadSheet.create do |s|
      s.style 'even-row-cell', :family => :cell
    end

    output.should have_tag('//office:automatic-styles/*', :count => 1)
    output.should have_tag('//style:style')
    Hpricot(output).at('//style:style')['style:name'].should == 'even-row-cell'
    Hpricot(output).at('//style:style')['style:family'].should == 'table-cell'
  end

  it "should have data styles" do
    output = ODF::SpreadSheet.create do |ss|
      ss.data_style 'year-to-day-long', :date
    end
    output.should have_tag('//office:automatic-styles/*', :count => 1)
    output.should have_tag('//number:date-style')
  end

  it "should allow conditional styles to be added" do
    output = ODF::SpreadSheet.create do |s|
      s.style 'cond-cell', :family => :cell do
        property :conditional,
        'condition' => 'cell-content()!=0',
        'apply-style-name' => 'red-cell'
      end
    end

    output.should have_tag('//style:map')
    Hpricot(output).at('//style:map')['style:apply-style-name'].should == 'red-cell'
  end

  it "should allow office styles to be added" do
    spread = ODF::SpreadSheet.new
    spread.office_style 'red-cell', :family => :cell

    output = spread.office_styles_xml

    output.should have_tag('//style:style')
    Hpricot(output).at('//style:style')['style:name'].should == 'red-cell'
    spread.xml.should_not have_tag('//style:style')
  end

  it "should support mixed office and conditional styles to be added" do
    spread = ODF::SpreadSheet.new
    spread.office_style 'red-cell', :family => :cell
    spread.style 'cond-cell', :family => :cell do
      property :conditional,
      'condition' => 'cell-content()!=0',
      'apply-style-name' => 'red-cell'
    end

    output = spread.styles_xml
    output.should have_tag('//style:map')
    Hpricot(output).at('//style:map')['style:apply-style-name'].should == 'red-cell'

    output = spread.office_styles_xml
    output.should have_tag('//style:style')
    Hpricot(output).at('//style:style')['style:name'].should == 'red-cell'
  end
end

