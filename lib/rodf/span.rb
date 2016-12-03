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

require 'builder'

require 'rodf/compatibility'
require 'rodf/paragraph_container'

module RODF
  class TextNode
    def initialize(content)
      @content = content
    end

    def xml
      @content.to_s.to_xs
    end
  end

  class Span < ParagraphContainer
    def initialize(first, second = nil)
      @style = nil

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
  end

  class ParagraphContainer < Container
    def span(*args)
      s = Span.new(*args)
      yield s if block_given?
      content_parts << s
      s
    end

    def <<(content)
      span(content)
    end

    def method_missing(style, *args)
      span(style, *args)
    end
  end
end

