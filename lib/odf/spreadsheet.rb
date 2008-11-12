require 'builder'

module ODF
  class SpreadSheet
    def self.create
      s = new
      yield s if block_given?
      s.content
    end
    
    def initialize
      @tables = []
    end

    def content
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
            xml << @tables.map {|t| t.content}.join("")
          end
        end
      end
    end

    def table(title)
      t = Table.new(title)
      yield t if block_given?
      @tables << t
    end
  end

  class Table
    def self.create(title)
      t = new(title)
      yield t if block_given?
      t.content
    end

    def initialize(title)
      @title = title
      @rows = []
    end

    def row
      r = Row.new
      yield r if block_given?
      @rows << r
    end

    def content
      xml = Builder::XmlMarkup.new
      xml.table:table, 'table:name' => @title do
        xml << @rows.map {|r| r.content}.join('')
      end
    end
  end

  class Row
    def content
      Builder::XmlMarkup.new.tag! 'table:table-row'
    end
  end
end
