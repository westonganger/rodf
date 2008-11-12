require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'odf/spreadsheet'

describe ODF::Cell do
  it "should hold text content" do
    output = ODF::Cell.new('Test').xml
    output.should have_tag('//table:table-cell')
    Hpricot(output).at('table:table-cell').innerHTML.should == 'Test'
  end
end
