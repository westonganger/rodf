# frozen_string_literal: true

module RODF
  class Hyperlink < ParagraphContainer
    def initialize(first, second = {})
      super

      if second.instance_of?(Hash) && second.empty?
        @href = first
      else
        span(first)
        @href = second.instance_of?(Hash) ? second[:href] : second
      end
    end

    def xml
      Builder::XmlMarkup.new.text:a, 'xlink:href' => @href do |a|
        a << content_parts_xml
      end
    end
  end

  class ParagraphContainer < Container
    def link(*args)
      l = Hyperlink.new(*args)

      yield l if block_given?

      content_parts << l

      l
    end
    alias a link
  end
end
