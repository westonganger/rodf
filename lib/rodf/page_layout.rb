# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require 'rodf/container'
require 'rodf/property'

module RODF
  class PageLayout < Container
    contains :properties

    def initialize(name)
      @name = name
    end

    def xml
      Builder::XmlMarkup.new.tag! 'style:page-layout', 'style:name' => @name do |b|
        b << properties_xml
      end
    end
  end
end
