# frozen_string_literal: true

module RODF
  class Spreadsheet < Document
    def xml
      builder = Builder::XmlMarkup.new

      builder.instruct!(:xml, version: '1.0', encoding: 'UTF-8')

      attrs = {
        'xmlns:office' => "urn:oasis:names:tc:opendocument:xmlns:office:1.0",
        'xmlns:table' => "urn:oasis:names:tc:opendocument:xmlns:table:1.0",
        'xmlns:text' => "urn:oasis:names:tc:opendocument:xmlns:text:1.0",
        'xmlns:oooc' => "http://openoffice.org/2004/calc",
        'xmlns:style' => "urn:oasis:names:tc:opendocument:xmlns:style:1.0",
        'xmlns:fo' => "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",
        'xmlns:number' => "urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0",
        'xmlns:xlink' => "http://www.w3.org/1999/xlink",
      }

      builder.tag!('office:document-content', attrs) do |xml|
        if !default_styles.empty?
          xml.tag! 'office:styles' do
            xml << default_styles_xml
          end
        end

        if !styles.empty? || !data_styles.empty?
          xml.tag! 'office:automatic-styles' do
            xml << styles_xml
            xml << data_styles_xml
          end
        end

        xml.office:body do
          xml.office:spreadsheet do
            xml << tables_xml
          end
        end
      end
    end

    def set_column_widths(table:, column_widths:)
      table.instance_variable_set(:@columns, []) ### Reset completely

      column_widths.each_with_index do |width, i|
        name = "col-width-#{i}"

        self.style(name, family: :column) do
          property(:column, {'column-width' => width})
        end

        table.columns << RODF::Column.new(style: name)
      end
    end

    def tables
      @tables ||= []
    end

    def table(*args, column_widths: nil, &block)
      x = Table.new(*args, &block)

      tables << x

      if column_widths
        set_column_widths(table: x, column_widths: column_widths)
      end

      return x
    end

    def tables_xml
      tables.map(&:xml).join
    end

    def add_tables(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        table(element)
      end
    end

    def data_styles
      @data_styles ||= []
    end

    def data_style(*args, &block)
      x = DataStyle.new(*args, &block)

      data_styles << x

      return x
    end

    def data_styles_xml
      data_styles.map(&:xml).join
    end

    def add_data_styles(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        data_style(element)
      end
    end
  end

  SpreadSheet = Spreadsheet
end
