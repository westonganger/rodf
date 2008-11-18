require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'odf/row'

describe ODF::Row do
  it "should allow cells to be added" do
    output = ODF::Row.create
    output.should have_tag('//table:table-row')
    output.should_not have_tag('//table:table-row/*')

    output = ODF::Row.create {|r|
      r.cell
      r.cell
    }
    output.should have_tag('//table:table-row/*', :count => 2)
    output.should have_tag('//table:table-cell')
  end
end
