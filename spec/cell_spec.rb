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
end
