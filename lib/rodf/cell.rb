# frozen_string_literal: true

module RODF
  class Cell < Container

    def initialize(value=nil, opts={})
      super

      if value.is_a?(Hash)
        opts = value
        value = opts[:value]
      else
        if value.is_a?(String)
          value = value.strip
        end
        opts = {} unless opts.is_a?(Hash)
      end

      @value = value || ''

      @type = opts[:type]

      unless empty?(@value)
        @url = opts[:url]

        if !@type
          if @value.is_a?(Numeric)
            @type = :float
          elsif @value.respond_to?(:strftime)
            ### for auto type inference force :date type because :time doesnt store any date info
            @type = :date
          else
            @type = :string
            @value = @value.to_s
          end
        end
      end

      ### TODO: set default DataStyle for the Spreadsheet for Date / Time / DateTime cells formatting

      @elem_attrs = make_element_attributes(@type, @value, opts)

      if opts[:attributes]
        @elem_attrs.merge!(opts[:attributes])
      end

      @multiplier = (opts[:span] || 1).to_i

      make_value_paragraph
    end

    def paragraphs
      @paragraphs ||= []
    end

    def paragraph(*args, &block)
      x = Paragraph.new(*args, &block)

      paragraphs << x

      return x
    end
    alias p paragraph

    def paragraphs_xml
      paragraphs.map(&:xml).join
    end

    def add_paragraphs(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        paragraph(element)
      end
    end

    def style=(style_name)
      @elem_attrs['table:style-name'] = style_name
    end

    def xml
      markup = Builder::XmlMarkup.new

      text = markup.tag! 'table:table-cell', @elem_attrs do |xml|
        xml << paragraphs_xml
      end

      (@multiplier - 1).times do
        text = markup.tag! 'table:table-cell'
      end

      text
    end

    def contains_url?
      !empty?(@url)
    end

    private

    def make_element_attributes(type, value, opts)
      attrs = {}

      if !empty?(value) || !opts[:formula].nil? || type == :string
        attrs['office:value-type'] = type
      end

      if type != :string && !empty?(value)
        case type
        when :date
          attrs['office:date-value'] = value
        when :time
          attrs['office:time-value'] = value
        else ### :float, :percentage, :currency
          attrs['office:value'] = value
        end
      end

      unless opts[:formula].nil?
        attrs['table:formula'] = opts[:formula]
      end

      unless opts[:style].nil?
        attrs['table:style-name'] = opts[:style]
      end

      unless opts[:span].nil?
        attrs['table:number-columns-spanned'] = opts[:span]
      end

      if opts[:matrix_formula]
        attrs['table:number-matrix-columns-spanned'] = 1
        attrs['table:number-matrix-rows-spanned'] = 1
      end

      return attrs
    end

    def make_value_paragraph
      if !empty?(@value)
        case @type
        when :float
          ### https://github.com/westonganger/rodf/issues/36
          value = @value
          paragraph do
            self << value
          end
        when :string
          cell, value, url = self, @value, @url

          # Split out newlines to be new cells since the text has been escaped at this point
          value.to_s.split("\n").each do |split_value|
            paragraph do
              if cell.contains_url?
                link split_value, href: url
              else
                self << split_value
              end
            end
          end
        end
      end
    end

    def empty?(value)
      value.respond_to?(:empty?) ? value.empty? : value.nil?
      #respond_to?(:empty?) ? (value.empty? || value =~ /\A[[:space:]]*\z/) : value.nil?
    end

  end
end
