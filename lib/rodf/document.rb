# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'zip'

require_relative 'container'
require_relative 'skeleton'
require_relative 'style'

module RODF
  class Document < Container
    contains :styles, :default_styles, :office_styles

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
  private
    def self.skeleton
      @skeleton ||= Skeleton.new
    end

    def self.doc_type
      name.split('::').last.downcase
    end
  end
end
