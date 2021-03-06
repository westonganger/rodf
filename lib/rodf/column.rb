module RODF
  class Column
    def initialize(opts={})
      @elem_attrs = {}

      @elem_attrs['table:style-name'] = opts[:style] unless opts[:style].nil?

      if opts[:attributes]
        @elem_attrs.merge!(opts[:attributes])
      end
    end

    def style=(style_name)
      @elem_attrs['table:style-name'] = style_name
    end

    def xml
      Builder::XmlMarkup.new.tag! 'table:table-column', @elem_attrs
    end
  end
end
