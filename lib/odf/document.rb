# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# rODF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with rODF.  If not, see <http://www.gnu.org/licenses/>.

require 'rubygems'

require 'zip'

require 'odf/container'
require 'odf/skeleton'
require 'odf/style'

module ODF
  class Document < Container
    contains :styles, :default_styles, :office_styles

    def self.file(ods_file_name, &contents)
      (doc = new).instance_eval(&contents)
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

