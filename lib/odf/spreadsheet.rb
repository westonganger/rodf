# Copyright (c) 2008 Thiago Arrais
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

require 'builder'
require 'zip/zip'

require 'odf/container'
require 'odf/style'
require 'odf/table'

module ODF
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

