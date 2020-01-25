require_relative 'spec_helper'

require_relative '../lib/rodf/master_page'

describe RODF::MasterPage do
  it "should have a name" do
    output = RODF::MasterPage.new('my-master-page').xml
    output.should have_tag('//style:master-page')

    Hpricot(output).at('style:master-page')['style:name'].should == 'my-master-page'
  end

  it "should accept a layout reference" do
    Hpricot(RODF::MasterPage.new('my-master-page', layout: 'A4').xml).
      at('style:master-page')['style:page-layout-name'].should == 'A4'
  end
end
