require 'rubygems'
require 'builder'

require 'odf/container'
require 'odf/row'

module ODF
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
end
