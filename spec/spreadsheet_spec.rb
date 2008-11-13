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
end
