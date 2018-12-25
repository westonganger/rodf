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

require_relative 'spec_helper'

require_relative '../lib/rodf/master_page'

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

