# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rodf/master_page'

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

