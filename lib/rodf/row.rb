module RODF
  class Row < Container
    attr_reader :number

    def initialize(number=0, opts={})
      @number = number

      @elem_attrs = {}

      @elem_attrs['table:style-name'] = opts[:style] unless opts[:style].nil?

      if opts[:attributes]
        @elem_attrs.merge!(opts[:attributes])
      end

      super
    end

    def cells
      @cells ||= []
    end

    def cell(*args, &block)
      x = Cell.new(*args, &block)

      cells << x

      return x
    end

    def cells_xml
      cells.map(&:xml).join
    end

    def style=(style_name)
      @elem_attrs['table:style-name'] = style_name
    end

    def add_cells(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        cell(element)
      end
    end

    def xml
      Builder::XmlMarkup.new.tag! 'table:table-row', @elem_attrs do |xml|
        xml << cells_xml
      end
    end
  end
end
