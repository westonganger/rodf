# frozen_string_literal: true

module RODF
  class StyleSection
    def initialize(type, second = {})
      @type = type

      if second.instance_of?(Hash)
        @elem_attrs = make_element_attributes(second)
      else
        @content, @elem_attrs = second, {}
      end
    end

    def xml
      Builder::XmlMarkup.new.number @type, @content, @elem_attrs
    end

    def make_element_attributes(opts)
      attrs = {}

      attrs['number:decimal-places'] = opts[:decimal_places] unless opts[:decimal_places].nil?

      attrs['number:grouping'] = opts[:grouping] unless opts[:grouping].nil?

      attrs['number:min-integer-digits'] = opts[:min_integer_digits] unless opts[:min_integer_digits].nil?

      attrs['number:style'] = opts[:style] unless opts[:style].nil?

      attrs['number:textual'] = opts[:textual] unless opts[:textual].nil?

      attrs
    end
  end
end
