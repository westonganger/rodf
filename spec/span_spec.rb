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

require 'rodf/span'

describe RODF::Span do
  it "should print non-styled spans in pure text" do
    RODF::Span.new('no style').xml.should == 'no style'
  end

  it "should wrap styled output in span tags" do
    output = RODF::Span.new(:italics, 'styled text').xml
    output.should have_tag('text:span')
    span = Hpricot(output).at('text:span')
    span['text:style-name'].should == 'italics'
    span.innerHTML.should == 'styled text'
  end

  it "should allow nesting" do
    output = RODF::Span.create :bold do |s|
      s.italics 'highlighted text'
    end

    output.should have_tag('//text:span/*', :count => 2)
    Hpricot(output).search('//text:span')[1].
      innerHTML.should == 'highlighted text'
  end

  it "should allow links" do
    output = RODF::Span.create :bold do |s|
      s.link 'there', 'http://www.example.org/'
      s << ' and '
      s.a 'back again', 'http://www.example.com/'
    end

    output.should have_tag('//text:a', :count => 2)
    elem = Hpricot(output)

    links = elem.search('//text:a')
    links.first.innerHTML.should == 'there'
    links.last.innerHTML.should == 'back again'

    elem.at('//text:span').children[1].to_plain_text.should == " and "
  end

  it "should escape entities" do
    RODF::Span.create('Fish & Chips').should == 'Fish &amp; Chips'
  end
end
