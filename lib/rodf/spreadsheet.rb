require_relative 'data_style'
require_relative 'document'
require_relative 'hyperlink'
require_relative 'span'
require_relative 'table'

module RODF
  class Spreadsheet < Document
    contains :tables, :data_styles

    def xml
      b = Builder::XmlMarkup.new

      b.instruct! :xml, version: '1.0', encoding: 'UTF-8'
      b.tag! 'office:document-content',
              'xmlns:office' => "urn:oasis:names:tc:opendocument:xmlns:office:1.0",
              'xmlns:table' => "urn:oasis:names:tc:opendocument:xmlns:table:1.0",
              'xmlns:text' => "urn:oasis:names:tc:opendocument:xmlns:text:1.0",
              'xmlns:oooc' => "http://openoffice.org/2004/calc",
              'xmlns:style' => "urn:oasis:names:tc:opendocument:xmlns:style:1.0",
              'xmlns:fo' => "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",
              'xmlns:number' => "urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0",
              'xmlns:xlink' => "http://www.w3.org/1999/xlink" do
      |xml|
        xml.tag! 'office:styles' do
          xml << default_styles_xml
        end unless default_styles.empty?
        xml.tag! 'office:automatic-styles' do
          xml << styles_xml
          xml << data_styles_xml
        end unless styles.empty? && data_styles.empty?
        xml.office:body do
          xml.office:spreadsheet do
            xml << tables_xml
          end
        end
      end
    end
  end

  SpreadSheet = Spreadsheet
end
