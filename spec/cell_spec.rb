require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'odf/spreadsheet'

describe ODF::Cell do
  it "should hold text content in a paragraph tag" do
    output = ODF::Cell.new('Test').xml
    output.should have_tag('//table:table-cell/*')
    output.should have_tag('//text:p')
    Hpricot(output).at('text:p').innerHTML.should == 'Test'
  end

  it "should have string as default value type" do
    output = ODF::Cell.new('Test').xml
    Hpricot(output).at('table:table-cell')['office:value-type'].should=='string'
  end

  it "should allow value types to be specified" do
    output = ODF::Cell.new(34.2, :type => :float).xml
    Hpricot(output).at('table:table-cell')['office:value-type'].should=='float'
  end
end
