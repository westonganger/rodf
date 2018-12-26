# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require_relative 'container'

module RODF
  # Container for all kinds of paragraph content
  class ParagraphContainer < Container
    def content_parts
      @content_parts ||= []
    end

    def content_parts_xml
      content_parts.map {|p| p.xml}.join
    end
  end
end
