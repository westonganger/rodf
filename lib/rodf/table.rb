module RODF
  class Table < Container
    def initialize(title = nil, spreadsheet: nil)
      @title = title

      @last_row = 0

      @spreadsheet = spreadsheet

      super
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

    def set_column_widths(*args)
      if args.first.is_a?(Array)
        col_widths = args.first
      else
        col_widths = args
      end

      @columns = [] ### Reset completely

      col_widths.each_with_index do |width, i|
        name = "col-width-#{i}"

        @spreadsheet.style(name, family: :column) do
          property(:column, {'column-width' => width})
        end

        @columns << RODF::Column.new(style: name)
      end
    end

    def xml
      Builder::XmlMarkup.new.table:table, 'table:name' => @title do |xml|
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
