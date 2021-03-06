module RODF
  class DataStyle < Container
    def initialize(name, type)
      super

      @type, @name = type, name
    end

    def style_sections
      @style_sections ||= []
    end

    def style_section(*args, &block)
      x = StyleSection.new(*args, &block)

      style_sections << x

      return x
    end
    alias section style_section

    def style_sections_xml
      style_sections.map(&:xml).join
    end

    def add_style_sections(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        style_section(element)
      end
    end

    def xml
      Builder::XmlMarkup.new.tag! "number:#{@type}-style", 'style:name' => @name do |xml|
        xml << style_sections_xml
      end
    end

    def method_missing(name, *args)
      section(name, *args)
    end
  end
end
