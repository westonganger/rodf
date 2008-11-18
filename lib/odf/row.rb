require 'rubygems'
require 'builder'

require 'odf/container'
require 'odf/cell'

module ODF
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
end

