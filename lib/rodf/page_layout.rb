# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require_relative 'container'
require_relative 'property'

module RODF
  class PageLayout < Container
    contains :properties

    def initialize(name)
      super

      @name = name
    end

    def xml
      Builder::XmlMarkup.new.tag! 'style:page-layout', 'style:name' => @name do |b|
        b << properties_xml
      end
    end
  end
end
