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

require 'zip/zip'

require 'odf/container'
require 'odf/skeleton'
require 'odf/style'

module ODF
  class Document < Container
    contains :styles, :default_styles, :office_styles

    def self.file(ods_file_name, &contents)
      ods_file = Zip::ZipFile.open(ods_file_name, Zip::ZipFile::CREATE)
      ods_file.get_output_stream('META-INF/manifest.xml') {|f| f << skeleton.manifest(doc_type) }

      (doc = new).instance_eval(&contents)

      ods_file.get_output_stream('styles.xml') do |f|
        f << skeleton.styles
        f << doc.office_styles_xml unless doc.office_styles.empty?
        f << "</office:styles> </office:document-styles>"
      end 
      ods_file.get_output_stream('content.xml') {|f| f << doc.xml}

      ods_file.close
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

