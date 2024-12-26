# frozen_string_literal: true

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
