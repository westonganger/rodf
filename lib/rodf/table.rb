module RODF
  class Table < Container
    def initialize(title = nil, opts ={})
      @title = title

      @last_row = 0

      @elem_attrs = {}

      @elem_attrs['table:style-name'] = opts[:style] unless opts[:style].nil?

      @elem_attrs['table:name'] = @title

      if opts[:attributes]
        @elem_attrs.merge!(opts[:attributes])
      end

      super
    end

    def style=(style_name)
      @elem_attrs['table:style-name'] = style_name
    end

    def rows
      @rows ||= []
    end

    def create_row(*args, &block)
      x = Row.new(*args, &block)

      rows << x

      return x
    end

    def rows_xml
      rows.map(&:xml).join
    end

    def row(options = {}, &contents)
      create_row(next_row, options) do |row|
        if contents
          if contents.arity.zero?
            row.instance_exec(row, &contents)
          else
            yield(row)
          end
        end
      end
    end

    def add_rows(*rows)
      if rows.first.first.is_a?(Array)
        rows = rows.first
      end

      rows.each do |row|
        new_row = self.row

        new_row.add_cells(row)
      end
    end

    def columns
      @columns ||= []
    end

    def column(options = {})
      x = Column.new(options)

      columns << x

      return x
    end

    def columns_xml
      columns.map(&:xml).join
    end

    def xml
      Builder::XmlMarkup.new.table :table, @elem_attrs do |xml|
        xml << columns_xml
        xml << rows_xml
      end
    end

    private

    def next_row
      @last_row += 1
    end

  end
end
