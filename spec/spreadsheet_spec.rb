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
end

