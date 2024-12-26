# frozen_string_literal: true

module RODF
  class Text < Document
    def xml
      b = Builder::XmlMarkup.new

      b.instruct! :xml, version: '1.0', encoding: 'UTF-8'

      attrs = {
        'xmlns:office' => "urn:oasis:names:tc:opendocument:xmlns:office:1.0",
        'xmlns:table' => "urn:oasis:names:tc:opendocument:xmlns:table:1.0",
        'xmlns:text' => "urn:oasis:names:tc:opendocument:xmlns:text:1.0",
        'xmlns:oooc' => "http://openoffice.org/2004/calc",
        'xmlns:style' => "urn:oasis:names:tc:opendocument:xmlns:style:1.0",
        'xmlns:fo' => "urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0",
        'xmlns:xlink' => "http://www.w3.org/1999/xlink",
      }

      b.tag! 'office:document-content', attrs do |xml|
        unless default_styles.empty?
          xml.tag! 'office:styles' do
            xml << default_styles_xml
          end
        end

        unless styles.empty? && page_layouts.empty?
          xml.tag! 'office:automatic-styles' do
            xml << styles_xml
            xml << page_layouts_xml
          end
        end

        unless master_pages.empty?
          xml.tag! 'office:master-styles' do
            xml << master_pages_xml
          end
        end

        xml.office:body do
          xml.office:text do
            xml << paragraphs_xml
          end
        end
      end
    end

    def paragraphs
      @paragraphs ||= []
    end

    def paragraph(*args, &block)
      x = Paragraph.new(*args, &block)

      paragraphs << x

      return x
    end
    alias p paragraph

    def paragraphs_xml
      paragraphs.map(&:xml).join
    end

    def add_paragraphs(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        paragraph(element)
      end
    end

    def page_layouts
      @page_layouts ||= []
    end

    def page_layout(*args, &block)
      x = PageLayout.new(*args, &block)

      page_layouts << x

      return x
    end

    def page_layouts_xml
      page_layouts.map(&:xml).join
    end

    def add_page_layouts(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        page_layout(element)
      end
    end

    def master_pages
      @master_pages ||= []
    end

    def master_page(*args, &block)
      x = MasterPage.new(*args, &block)

      master_pages << x

      return x
    end

    def master_pages_xml
      master_pages.map(&:xml).join
    end

    def add_master_pages(*elements)
      if elements.first.is_a?(Array)
        elements = elements.first
      end

      elements.each do |element|
        master_pages(element)
      end
    end

  end
end
