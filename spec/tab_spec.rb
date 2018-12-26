# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rodf/paragraph'
require 'rodf/tab'

describe RODF::Tab do
  it "should be placed inside paragraphs" do
    output = RODF::Paragraph.create {|p|
      p << "Tab"
      p.tab
      p << "test"
    }
    output.should have_tag("//text:p/*", count: 3)
    output.should have_tag("//text:tab")
  end
end
