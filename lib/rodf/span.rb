# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require_relative 'compatibility'
require_relative 'paragraph_container'

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
      super

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
