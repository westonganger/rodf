# frozen_string_literal: true

module RODF
  class TextNode
    def initialize(content)
      @content = content
    end

    def xml
      Builder::XChar.encode(@content.to_s)
    end
  end

  class Span < ParagraphContainer
    def initialize(first, second=nil, style: nil, &block)
      super(first, second, &block)

      @style = nil

      if first.instance_of?(Symbol)
        ### Legacy behaviour

        @style = first

        if !second.nil?
          content_parts << TextNode.new(second)
        end
      else
        if style
          @style = style
        end

        content_parts << TextNode.new(first)
      end
    end

    def xml
      if @style.nil?
        return content_parts_xml
      end

      Builder::XmlMarkup.new.text(:span, 'text:style-name' => @style) do |xml|
        xml << content_parts_xml
      end
    end
  end
end
