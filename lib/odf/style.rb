require 'rubygems'
require 'builder'

require 'odf/container'
require 'odf/property'

module ODF
  class Style < Container
    contains :properties
    
    FAMILIES = {:cell => 'table-cell'}

    def initialize(name='', opts={})
      @name = name
      @family = FAMILIES[opts[:family]]
    end

    def xml
      Builder::XmlMarkup.new.style:style, 'style:name' => @name,
                                          'style:family' => @family do
      |xml|
        xml << properties_xml
      end
    end
  end 
end

