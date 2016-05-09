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

require 'odf/text'
require "tempfile"

describe "file storage" do

  before do
    @default_internal = Encoding.default_internal
    @tempfilename = Tempfile.create("text") { |f| f.path }
  end

  after do
    Encoding.default_internal = @default_internal
    File.unlink @tempfilename if File.exist? @tempfilename
  end

  it "should store files on disk" do
    ODF::Text.file(@tempfilename) {}

    File.exist?(@tempfilename).should be true
  end

  it "should with with Encoding.default_internal" do
    Encoding.default_internal = "UTF-8"

    ODF::Text.file(@tempfilename) {}
    File.exist?(@tempfilename).should be true
  end
end
