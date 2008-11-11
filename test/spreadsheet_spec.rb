$:.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))

require 'rspec_hpricot_matchers'
include RspecHpricotMatchers

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
    output.should have_tag('//office:spreadsheet/*', :count => 0)
  end
end