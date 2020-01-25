require_relative 'spec_helper'

require_relative '../lib/rodf/style_section'

describe RODF::StyleSection do
  it "should allow style attribute" do
    output = RODF::StyleSection.new(:year, style: 'long').xml
    output.should have_tag('number:year')
    Hpricot(output).at('number:year')['number:style'].should == 'long'
  end

  it "should allow decimal-places attribute" do
    output = RODF::StyleSection.new(:number, decimal_places: '2').xml
    output.should have_tag('number:number')
    Hpricot(output).at('number:number')['number:decimal-places'].should == '2'
  end

  it "should allow min-integer-digits attribute" do
    output = RODF::StyleSection.new(:number, min_integer_digits: '1').xml
    output.should have_tag('number:number')
    Hpricot(output).at('number:number')['number:min-integer-digits'].should == '1'
  end

  it "should allow grouping flag" do
    output = RODF::StyleSection.new(:number, grouping: true).xml
    Hpricot(output).at('number:number')['number:grouping'].should == 'true'
  end

  it "should allow textual flag" do
    output = RODF::StyleSection.new(:month, textual: true).xml
    Hpricot(output).at('number:month')['number:textual'].should == 'true'
  end

  it "should allow text to be inserted" do
    Hpricot(RODF::StyleSection.new(:text, 'content').xml).
      at('number:text').innerHTML.should == 'content'

    Hpricot(RODF::StyleSection.new(:day).xml).
      at('number:day').innerHTML.should == ''
  end
end
