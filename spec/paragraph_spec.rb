# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# rODF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with rODF.  If not, see <http://www.gnu.org/licenses/>.

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'rodf/paragraph'

describe RODF::Paragraph do
  it "should allow text content inside" do
    output = RODF::Paragraph.new('Hello').xml
    output.should have_tag('//text:p')
    Hpricot(output).at('text:p').innerHTML.should == 'Hello'
  end

  it "should accept an input sequence" do
    output = RODF::Paragraph.create { |p|
      p << "Hello, "
      p << "world!"
    }
    output.should have_tag('//text:p')
    Hpricot(output).at('text:p').innerHTML.should == 'Hello, world!'
  end

  it "should accept styled spans" do
    output = RODF::Paragraph.create { |p|
      p << "Hello, "
      p.span :bold, "world! "
      p << "This is not bold. "
      p.bold "But this is."
    }
    spans = Hpricot(output).at('text:p').search('text:span')
    spans.first.innerHTML.should == 'world! '
    spans.first['text:style-name'].should == 'bold'
    spans.last.innerHTML.should == 'But this is.'
    spans.last['text:style-name'].should == 'bold'
  end

  it "should be able to hold hyperlinks" do
    output = RODF::Paragraph.create {|p|
      p << "please visit "
      p.a "example.org", href: "http://www.example.org/"
      p << " for more details"
    }
    output.should have_tag("//text:p/*", count: 3)
    output.should have_tag("//text:a")

    Hpricot(output).at('text:a').innerHTML.should == 'example.org'
  end

  it "should support style attribute" do
    Hpricot(RODF::Paragraph.create('styled paragraph', style: 'highlight')).
      at('text:p')['text:style-name'].should == 'highlight'
  end

  it "should accept attributes in the first parameter too" do
    para = Hpricot(RODF::Paragraph.create(style: 'testing')).at('text:p')
    para.innerHTML.should be_empty
    para['text:style-name'].should == 'testing'
  end
end
