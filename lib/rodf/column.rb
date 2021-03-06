module RODF
  class Column
    def initialize(opts={})
      @elem_attrs = {}

      @elem_attrs['table:style-name'] = opts[:style] unless opts[:style].nil?
    end

    def xml
      Builder::XmlMarkup.new.tag! 'table:table-column', @elem_attrs
    end
  end
end
