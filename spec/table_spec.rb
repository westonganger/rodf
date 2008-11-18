require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'odf/table'

describe ODF::Table do
  it "should allow rows to be added" do
    output = ODF::Table.create('Example') {|t| }
    output.should have_tag('//table:table')
    output.should_not have_tag('//table:table/*')

    output = ODF::Table.create('MyTable') {|t| t.row }
    output.should have_tag('//table:table/*', :count => 1)
    output.should have_tag('//table:table-row')

    output = ODF::Table.create('MyTable') {|t|
      t.row
      t.row
    }
    output.should have_tag('//table:table/*', :count => 2)
    output.should have_tag('//table:table-row')
  end

  it "should provide row numbers" do
    output = ODF::Table.create('Row letter table') {|t|
      t.row {|row| row.cell}
      t.row {|row| row.cell(row.number)}
    }
    output.should have_tag('text:p')
    Hpricot(output).at('text:p').innerHTML.should == '2'
  end
end
