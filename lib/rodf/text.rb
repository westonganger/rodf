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

require 'builder'

require_relative 'document'
require_relative 'master_page'
require_relative 'page_layout'
require_relative 'paragraph'
require_relative 'span'
require_relative 'hyperlink'

module RODF
  class Text < Document
    contains :paragraphs, :page_layouts, :master_pages

    alias :p :paragraph

    def xml
      b = Builder::XmlMarkup.new

      b.instruct! :xml, version: '1.0', encoding: 'UTF-8'
      b.tag! 'office:document-content', 'xmlns:office' => "urn:oasis:names:tc:opendocument:xmlns:office:1.0",
                                        'xmlns:table' => "urn:oasis:names:tc:opendocument:xmlns:table:1.0",
                                        'xmlns:text' => "urn:oasis:names:tc:opendocument:xmlns:text:1.0",
                                        'xmlns:oooc' => "http://openoffice.org/2004/calc",
                                        'xmlns:style' => "urn:oasis:names:tc:opendocument:xmlns:style:1.0",
                                        'xmlns:fo' => "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",
                                        'xmlns:xlink' => "http://www.w3.org/1999/xlink" do
      |xml|
        xml.tag! 'office:styles' do
          xml << default_styles_xml
        end unless default_styles.empty?
        xml.tag! 'office:automatic-styles' do
          xml << styles_xml
          xml << page_layouts_xml
        end unless styles.empty? && page_layouts.empty?
        xml.tag! 'office:master-styles' do
          xml << master_pages_xml
        end unless master_pages.empty?
        xml.office:body do
          xml.office:text do
            xml << paragraphs_xml
          end
        end
      end
    end
  end
end

