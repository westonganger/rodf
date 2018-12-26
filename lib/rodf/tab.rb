# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require_relative 'paragraph_container'

module RODF
  class Tab
    def xml
      Builder::XmlMarkup.new.text:tab
    end
  end

  class ParagraphContainer < Container
    def tab(*args)
      t = Tab.new
      content_parts << t
      t
    end
  end
end

