require_relative 'spec_helper'

describe RODF::Column do
  it "should accept parameterless blocks" do
    col = RODF::Column.new
    col.xml.should include('<table:table-column/>')
  end

  it "should be stylable in the initialization" do
    col = RODF::Column.new(style: 'dark')
    Hpricot(col.xml).at('table:table-column')['table:style-name'].should == 'dark'
  end

  it "should be attr_writer stylable" do
    column = RODF::Column.new
    column.style = 'dark'
    Hpricot(column.xml).at('table:table-column')['table:style-name'].should == 'dark'
  end

  it "should allow arbitrary XML attributes" do
    element = RODF::Column.new(attributes: {foobar: true})
    element.xml.should include('<table:table-column foobar="true"/>')
  end

end
