require_relative 'spec_helper'

describe RODF::PageLayout do
  it "should have a name" do
    output = RODF::PageLayout.new('main-layout').xml
    output.should have_tag('style:page-layout')
    Hpricot(output).at('style:page-layout')['style:name'].should == 'main-layout'
  end

  it "should have properties" do
    output = RODF::PageLayout.create 'main-layout' do |l|
      l.property 'page-layout'
    end
    output.should have_tag('//style:page-layout/*', count: 1)
    output.should have_tag('style:page-layout-properties')
  end

  it "should accept parameterless blocks" do
    output = RODF::PageLayout.create 'main-layout' do
      property 'page-layout'
    end
    output.should have_tag('//style:page-layout/*', count: 1)
    output.should have_tag('style:page-layout-properties')
  end
end
