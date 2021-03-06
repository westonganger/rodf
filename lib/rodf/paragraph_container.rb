module RODF
  # Container for all kinds of paragraph content
  class ParagraphContainer < Container
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

    def <<(content)
      span(content)
    end

    def method_missing(style, *args)
      span(style, *args)
    end
  end
end
