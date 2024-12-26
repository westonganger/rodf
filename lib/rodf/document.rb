# frozen_string_literal: true

module RODF
  class Document < Container
    def self.file(ods_file_name, &contents)
      doc = new

      if contents.arity.zero?
        contents.call(doc)
      else
        doc.instance_exec(doc, &contents)
      end

      doc.write_to ods_file_name
    end

    def write_to(ods_file_name)
      File.open(ods_file_name, 'wb') { |f| f << self.bytes }
    end

    def bytes
      buffer = Zip::OutputStream::write_buffer do |zio|
        zio.put_next_entry('META-INF/manifest.xml')

        zio << self.class.skeleton.manifest(self.class.doc_type)

        zio.put_next_entry('styles.xml')

        zio << self.class.skeleton.styles

        zio << self.office_styles_xml unless self.office_styles.empty?

        zio << "</office:styles> </office:document-styles>"

        zio.put_next_entry('content.xml')

        zio << self.xml
      end

      buffer.set_encoding('ASCII-8BIT')

      buffer.rewind

      buffer.sysread
    end

    def styles
      @styles ||= []
    end

    def style(*args, &block)
      x = Style.new(*args, &block)

      styles << x

      return x
    end

    def styles_xml
      styles.map(&:xml).join
    end

    def add_styles(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        style(element)
      end
    end

    def default_styles
      @default_styles ||= []
    end

    def default_style(*args, &block)
      x = DefaultStyle.new(*args, &block)

      default_styles << x

      return x
    end

    def default_styles_xml
      default_styles.map(&:xml).join
    end

    def add_default_styles(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        default_style(element)
      end
    end

    def office_styles
      @office_styles ||= []
    end

    def office_style(*args, &block)
      x = OfficeStyle.new(*args, &block)

      office_styles << x

      return x
    end

    def office_styles_xml
      office_styles.map(&:xml).join
    end

    def add_office_styles(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        office_style(element)
      end
    end

    private

    def self.skeleton
      @skeleton ||= Skeleton.new
    end

    def self.doc_type
      name.split('::').last.downcase
    end
  end
end
