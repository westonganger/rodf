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

require 'odf/style_section'

describe ODF::StyleSection do
  it "should allow style attribute" do
    output = ODF::StyleSection.new(:year, :style => 'long').xml
    output.should have_tag('number:year')
    Hpricot(output).at('number:year')['number:style'].should == 'long'
  end

  it "should allow textual flag" do
    output = ODF::StyleSection.new(:month, :textual => true).xml
    Hpricot(output).at('number:month')['number:textual'].should == 'true'
  end
end

