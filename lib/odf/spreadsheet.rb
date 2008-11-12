require 'builder'

require 'odf/meta_stuff'

module ODF
  class Cell
    def initialize(value='', opts={})
      @type = opts[:type] || 'string'
      @value = value
    end

    def xml
      Builder::XmlMarkup.new.tag! 'table:table-cell',
        'office:value-type' => @type do
      |xml|
        xml << @value.to_s
      end
    end
  end

  Row = ODF::container_of :cells
  class Row
    def xml
      Builder::XmlMarkup.new.tag! 'table:table-row' do |xml|
        xml << children_xml
      end
    end
  end

  Table = ODF::container_of :rows
  class Table
    def initialize(title)
      @title = title
    end

    def xml
      Builder::XmlMarkup.new.table:table, 'table:name' => @title do |xml|
        xml << children_xml
      end
    end
  end

  SpreadSheet = ODF::container_of :tables
  class SpreadSheet
    def xml
      b = Builder::XmlMarkup.new

      b.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'
      b.tag! 'office:document-content', 'xmlns:office' => "urn:oasis:names:tc:opendocument:xmlns:office:1.0",
                                        'xmlns:table' => "urn:oasis:names:tc:opendocument:xmlns:table:1.0",
                                        'xmlns:text' => "urn:oasis:names:tc:opendocument:xmlns:text:1.0",
                                        'xmlns:oooc' => "http://openoffice.org/2004/calc",
                                        'xmlns:style' => "urn:oasis:names:tc:opendocument:xmlns:style:1.0",
                                        'xmlns:fo' => "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" do
      |xml|
        xml.office:body do
          xml.office:spreadsheet do
            xml << children_xml
          end
        end
      end
    end
  end
end

