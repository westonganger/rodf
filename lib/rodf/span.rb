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
end
