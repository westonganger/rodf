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
require 'odf/hyperlink'

module ODF
  class TextNode
    def initialize(content)
      @content = content
    end

    def xml
      @content
    end
  end

  class Span < Container
    def initialize(first, second = nil)
      if first.instance_of?(Symbol)
        @style = first
        content_parts << TextNode.new(second) unless second.nil?
      else
        content_parts << TextNode.new(first)
      end
    end

    def xml
      return content_parts_xml if @style.nil?
      Builder::XmlMarkup.new.text:span, 'text:style-name' => @style do |xml|
        xml << content_parts_xml
      end
    end

    def content_parts
      @content_parts ||= []
    end

    def content_parts_xml
      content_parts.map {|p| p.xml}.join
    end

    def span(*args)
      s = Span.new(*args)
      yield s if block_given?
      content_parts << s
      s
    end

    def link(*args)
      l = Hyperlink.new(*args)
      yield l if block_given?
      content_parts << l
      l
    end
    alias a link

    def <<(content)
      span(content)
    end

    def method_missing(style, *args)
      span(style, *args)
    end
  end
end

