require 'rubygems'
require 'builder'

module ODF
  class Property
    PROPERTY_NAMES = {:cell => 'style:table-cell-properties',
                      :text => 'style:text-properties'}

    def initialize(type, specs={})
      @name = PROPERTY_NAMES[type]
      @specs = specs
    end

    def xml
      specs = {}
      @specs.each do |k, v|
        specs['fo:' + k] = v
      end
      Builder::XmlMarkup.new.tag! @name, specs
    end
  end
end

