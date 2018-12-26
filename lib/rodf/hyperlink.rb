# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require_relative 'paragraph_container'

module RODF
  class Hyperlink < ParagraphContainer
    def initialize(first, second = {})
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
