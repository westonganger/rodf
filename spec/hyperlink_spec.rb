# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require_relative 'spec_helper'

require_relative '../lib/rodf/hyperlink'

describe RODF::Hyperlink do
  it "should receive content text in first argument" do
    output = RODF::Hyperlink.new('link somewhere', href: 'http://www.example.org/').xml
    output.should have_tag('//text:a')

    link = Hpricot(output).at('text:a')
    link.innerHTML.should == 'link somewhere'
    link['xlink:href'].should == 'http://www.example.org/'
  end

  it "should accept ref both in second argument as in argument hash" do
    Hpricot(RODF::Hyperlink.new('link somewhere', href: 'http://www.example.org/').xml).
      at('text:a')['xlink:href'].should == 'http://www.example.org/'

    Hpricot(RODF::Hyperlink.new('link somewhere', 'http://www.example.org/').xml).
      at('text:a')['xlink:href'].should == 'http://www.example.org/'
  end

  it "should allow nested span elements" do
    output = RODF::Hyperlink.create 'http://www.example.com/' do |link|
      link.strong 'important link'
    end

    output.should have_tag('//text:a/*', count: 1)
    tree = Hpricot(output)
    tree.at('//text:a')['xlink:href'].should == 'http://www.example.com/'
    span = tree.at('//text:span')
    span['text:style-name'].should == 'strong'
    span.innerHTML.should == 'important link'
  end

  it "should accept parameterless blocks" do
    output = RODF::Hyperlink.create 'http://www.example.com/' do
      strong 'important link'
    end

    output.should have_tag('//text:a/*')
    output.should have_tag('//text:span/*')
  end
end
