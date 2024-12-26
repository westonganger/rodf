# frozen_string_literal: true

module RODF
  class PageLayout < Container
    def initialize(name)
      super

      @name = name
    end

    def properties
      @properties ||= []
    end

    def property(*args, &block)
      x = Property.new(*args, &block)

      properties << x

      return x
    end

    def properties_xml
      properties.map(&:xml).join
    end

    def add_properties(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        property(element)
      end
    end

    def xml
      Builder::XmlMarkup.new.tag! 'style:page-layout', 'style:name' => @name do |b|
        b << properties_xml
      end
    end
  end
end
