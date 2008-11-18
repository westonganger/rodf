require 'builder'
require 'zip/zip'

require 'odf/container'

module ODF
  class Cell
    def initialize(*args)
      value = args.first || ''
      opts = args.last.instance_of?(Hash) ? args.last : {}

      @type = opts[:type] || :string
      @formula = opts[:formula]
      @style = opts[:style]
      @value = value.to_s.strip unless value.instance_of? Hash
    end

    def xml
      elem_attrs = {'office:value-type' => @type}
      elem_attrs['office:value'] = @value unless contains_string?
      elem_attrs['table:formula'] = @formula unless @formula.nil?
      elem_attrs['table:style-name'] = @style unless @style.nil?

      Builder::XmlMarkup.new.tag! 'table:table-cell', elem_attrs do |xml|
        xml.text(:p, @value) if contains_string?
      end
    end

    def contains_string?
      :string == @type && !@value.nil? && !@value.empty?
    end
  end

  class Row < Container
    contains :cells
    attr_reader :number

    def initialize(number=0)
      @number = number
    end

    def xml
      Builder::XmlMarkup.new.tag! 'table:table-row' do |xml|
        xml << cells_xml
      end
    end
  end

  class Table < Container
    contains :rows    

    def initialize(title)
      @title = title
      @last_row = 0
    end

    alias create_row row
    def row
      create_row(next_row) {|r| yield r if block_given?}
    end

    def xml
      Builder::XmlMarkup.new.table:table, 'table:name' => @title do |xml|
        xml << rows_xml
      end
    end
  private
    def next_row
      @last_row += 1
    end
  end

  class Property
    PROPERTY_NAMES = {:cell => 'style:table-cell-properties',
                      :text => 'style:text-properties'}

    def initialize(type, specs={})
      @name = PROPERTY_NAMES[type]
      @specs = specs
    end

    def xml
      specs = {}
      @specs.each do |k, v|
        specs['fo:' + k] = v
      end
      Builder::XmlMarkup.new.tag! @name, specs
    end
  end

  class Style < Container
    contains :propertys
    
    FAMILIES = {:cell => 'table-cell'}

    def initialize(name='', opts={})
      @name = name
      @family = FAMILIES[opts[:family]]
    end

    def xml
      Builder::XmlMarkup.new.style:style, 'style:name' => @name,
                                          'style:family' => @family do
      |xml|
        xml << propertys_xml
      end
    end
  end 

  class SpreadSheet < Container
    contains :tables, :styles

    def self.file(ods_file_name)
      ods_file = Zip::ZipFile.open(ods_file_name, Zip::ZipFile::CREATE)
      ods_file.get_output_stream('styles.xml') {|f| f << skeleton('styles.xml')}
      ods_file.get_output_stream('META-INF/manifest.xml') {|f| f << skeleton('manifest.xml')}
      
      yield(spreadsheet = new)

      ods_file.get_output_stream('content.xml') {|f| f << spreadsheet.xml}

      ods_file.close
    end

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
        xml.tag! 'office:automatic-styles' do
          xml << styles_xml
        end unless styles.empty?
        xml.office:body do
          xml.office:spreadsheet do
            xml << tables_xml
          end
        end
      end
    end

  private
    def self.skeleton(fname)
      File.open(File.dirname(__FILE__) + '/skeleton/' + fname).read
    end
  end
end

