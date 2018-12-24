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

require 'rodf/hyperlink'

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
