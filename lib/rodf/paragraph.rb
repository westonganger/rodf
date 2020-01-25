require 'builder'

require_relative 'paragraph_container'

module RODF
  class Paragraph < ParagraphContainer
    def initialize(fst = nil, snd = {})
      super

      first_is_hash = fst.instance_of? Hash
      span(fst) unless first_is_hash
      @elem_attrs = make_element_attributes(first_is_hash ? fst : snd)
    end

    def xml
      Builder::XmlMarkup.new.text:p, @elem_attrs do |xml|
        xml << content_parts_xml
      end
    end

  private

    def make_element_attributes(opts)
      attrs = {}
      attrs['text:style-name'] = opts[:style] unless opts[:style].nil?
      attrs
    end

  end
end
