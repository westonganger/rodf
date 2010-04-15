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

require 'rubygems'
require 'builder'

require 'odf/container'
require 'odf/span'

module ODF
  class Paragraph < Container
    contains :spans

    def initialize(content = nil)
      span(content)
    end

    def xml
      Builder::XmlMarkup.new.text:p do |xml|
        xml << spans_xml
      end
    end

    def <<(content)
      span(content)
    end

    def method_missing(style, *args)
      span(style, *args)
    end
  end
end
