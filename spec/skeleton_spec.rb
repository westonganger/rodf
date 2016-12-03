# Copyright (c) 2012 Foivos Zakkak
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

require 'rodf/skeleton'

describe RODF::Skeleton do
  it "should have the expected structure" do
    output = RODF::Skeleton.new.styles
    output.should have_tag('//office:document-styles/*')
    output.should have_tag('//office:font-face-decls')
    output.should have_tag('//office:styles', count: 1)
    output.should have_tag('//style:style', count: 1)
    output.should have_tag('//number:number-style', count: 2)
    output.should have_tag('//number:date-style', count: 1)
  end
end

