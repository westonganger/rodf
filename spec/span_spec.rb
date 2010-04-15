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

require 'odf/span'

describe ODF::Span do
  it "should print non-styled spans in pure text" do
    ODF::Span.new('no style').xml.should == 'no style'
  end

  it "should wrap styled output in span tags" do
    output = ODF::Span.new(:italics, 'styled text').xml
    output.should have_tag('text:span')
    span = Hpricot(output).at('text:span')
    span['text:style-name'].should == 'italics'
    span.innerHTML.should == 'styled text'
  end
end
