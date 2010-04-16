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

require 'odf/data_style'

describe ODF::DataStyle do
  it "should have sections" do
    output = ODF::DataStyle.create 'year-to-day', :date do |s|
      s.section :year, :style => 'long'
      s.section :month, :style => 'long'
      s.section :day
    end

    output.should have_tag('number:date-style')
    output.should have_tag('number:year')
    output.should have_tag('number:month')
    output.should have_tag('number:day')

    Hpricot(output).at('number:date-style')['style:name'].should == 'year-to-day'
  end

  it "should allow short section names" do
    output = ODF::DataStyle.create 'year-to-day', :date do |number|
      number.year :style => 'long'
      number.month :style => 'long'
      number.day
    end

    output.should have_tag('number:year')
    output.should have_tag('number:month')
    output.should have_tag('number:day')
  end
end

