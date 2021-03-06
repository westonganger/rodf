require_relative 'spec_helper'

require 'date'

CELL_TYPES = [:float, :date, :time, :percentage, :currency].freeze

describe RODF::Cell do
  ### GENERAL & STRING
  it "should hold text content in a paragraph tag" do
    output = RODF::Cell.new('Test').xml
    output.should have_tag('//table:table-cell/*')
    output.should have_tag('//text:p')
    Hpricot(output).at('text:p').innerHTML.should == 'Test'
  end

  it "should contain paragraph" do
    c = RODF::Cell.new
    c.paragraph "testing"
    output = c.xml

    output.should have_tag("//table:table-cell/*", count: 1)
    output.should have_tag("//text:p")

    Hpricot(output).at('text:p').innerHTML.should == 'testing'
  end

  it "should be able to hold multiple paragraphs" do
    output = RODF::Cell.create do |c|
      c.paragraph "first"
      c.paragraph "second"
    end

    output.should have_tag("//table:table-cell/*", count: 2)
    output.should have_tag("//text:p")

    ps = Hpricot(output).search('text:p')
    ps[0].innerHTML.should == 'first'
    ps[1].innerHTML.should == 'second'
  end

  it "should not render value type for non-string nil values" do
    Hpricot(RODF::Cell.new(nil, type: :string).xml).at('table:table-cell').innerHTML.should == ''

    CELL_TYPES.each do |t|
      cell = Hpricot(RODF::Cell.new(nil, type: t).xml).at('table:table-cell')
      cell.innerHTML.should == ''
      cell['office:value'].should be_nil
      cell['office:date-value'].should be_nil
      cell['office:value-type'].should be_nil
    end
  end

  it "should accept parameterless blocks" do
    output = RODF::Cell.create do
      paragraph "first"
      paragraph "second"
    end

    output.should have_tag("//table:table-cell/*", count: 2)
    output.should have_tag("//text:p")

    ps = Hpricot(output).search('text:p')
    ps[0].innerHTML.should == 'first'
    ps[1].innerHTML.should == 'second'
  end

  it "should not have an empty paragraph" do
    [RODF::Cell.new, RODF::Cell.new(''), RODF::Cell.new('  ')].each do |cell|
      cell.xml.should_not have_tag('text:p')
    end
  end

  it "should span multiple cells when asked to" do
    cell = RODF::Cell.new 'Spreadsheet title', span: 4
    doc = Hpricot(cell.xml)
    doc.at('table:table-cell')['table:number-columns-spanned'].should == '4'
    doc.search('table:table-cell').size.should == 4
  end

  it "should have the URL set correctly when requested on a string" do
    cell = RODF::Cell.new 'Example Link', url: 'http://www.example.org'
    doc = Hpricot(cell.xml)
    doc.at('text:a')['xlink:href'].should == 'http://www.example.org'
  end

  it "should ignore the URL requested on anything other than a string" do
    cell = RODF::Cell.new(47.1, type: :float, url: 'http://www.example.org')
    cell.xml.should_not have_tag('text:a')

    cell = RODF::Cell.new(Date.parse('15 Apr 2010'), type: :date, url: 'http://www.example.org')
    cell.xml.should_not have_tag('text:p')
    cell.xml.should_not have_tag('text:a')
  end

  it "should respect newlines and split across multiple text:p cells" do
    c = RODF::Cell.new("testing1\ntesting2")
    output = c.xml

    output.should have_tag("//text:p", count: 2)

    ps = Hpricot(output).search('text:p')
    ps[0].innerHTML.should == 'testing1'
    ps[1].innerHTML.should == 'testing2'
  end

  ### FLOAT
  it "should allow value types to be specified" do
    output = RODF::Cell.new(34.2, type: :float).xml
    Hpricot(output).at('table:table-cell')['office:value-type'].should=='float'
  end

  it "should place floats values in value attribute and paragraph tag" do
    output = RODF::Cell.new(34.2, type: :float).xml

    Hpricot(output).at('table:table-cell')['office:value'].should == '34.2'

    #output.should_not have_tag('//table:table-cell/*')
    output.should have_tag('//text:p')
    Hpricot(output).at('text:p').innerHTML.should == '34.2'
  end

  it "shoud allow float values in string cells" do
    output = RODF::Cell.new(34.2, type: :string).xml
    output.should have_tag('//text:p')
    Hpricot(output).at('text:p').innerHTML.should == '34.2'
  end

  it "should accept formulas" do
    output = RODF::Cell.new(type: :float, formula: "oooc:=SUM([.A1:.A4])").xml

    elem = Hpricot(output).at('table:table-cell')
    elem['office:value-type'].should == 'float'
    elem['table:formula'].should == 'oooc:=SUM([.A1:.A4])'
  end

  it "should accept matrix formulas" do
    output = RODF::Cell.new(type: :float, matrix_formula: true, formula: "oooc:=SUM([.A1:.A4])").xml

    elem = Hpricot(output).at('table:table-cell')
    elem['table:number-matrix-columns-spanned'].should == '1'
    elem['table:number-matrix-rows-spanned'].should == '1'
  end

  it "should not make a matrix formula when asked not too" do
    output = RODF::Cell.new(type: :float, matrix_formula: false, formula: "oooc:=SUM([.A1:.A4])").xml

    elem = Hpricot(output).at('table:table-cell')
    elem['table:number-matrix-columns-spanned'].should be_nil
    elem['table:number-matrix-rows-spanned'].should be_nil
  end

  it "should allow an style to be specified in the constructor" do
    cell = RODF::Cell.new 45.8, type: :float, style: 'left-column-cell'
    Hpricot(cell.xml).at('table:table-cell')['table:style-name'].should == 'left-column-cell'
  end

  it "should allow and style to be specified through a method call" do
    cell = RODF::Cell.new 45.8, type: :float
    cell.style = 'left-column-cell'
    Hpricot(cell.xml).at('table:table-cell')['table:style-name'].should == 'left-column-cell'
  end

  it "should allow arbitrary XML attributes" do
    element = RODF::Cell.new(attributes: {foobar: true})
    element.xml.should include('<table:table-cell foobar="true">')
  end

  ### DATE
  it "should have the date set correctly" do
    date = Date.parse('2010-04-15')
    cell = Hpricot(RODF::Cell.new(date, type: :date).xml).at('table:table-cell')
    cell['office:value-type'].should == 'date'
    cell['office:date-value'].should == date.to_s
    cell['office:value'].should be_nil
    cell['office:time-value'].should be_nil
  end

  ### TIME
  it "should have the time set correctly" do
    time = Time.now
    cell = Hpricot(RODF::Cell.new(time, type: :time).xml).at('table:table-cell')
    cell['office:value-type'].should == 'time'
    cell['office:time-value'].should == time.to_s
    cell['office:value'].should be_nil
    cell['office:date-value'].should be_nil
  end

  ### PERCENTAGE
  it "should have the percentage set correctly" do
    number = 0.45
    rodf_cell = RODF::Cell.new(number, type: :percentage)
    output = Hpricot(rodf_cell.xml)
    cell = output.at('table:table-cell')
    cell['office:value-type'].should == 'percentage'
    cell['office:value'].should == number.to_s
  end

  ### CURRENCY
  it "should have the currency set correctly" do
    number = 1234.5678
    output = Hpricot(RODF::Cell.new(number, type: :currency).xml)
    cell = output.at('table:table-cell')
    cell['office:value-type'].should == 'currency'
    cell['office:value'].should == number.to_s
  end

end
