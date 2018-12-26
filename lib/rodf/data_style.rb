# Copyright (c) 2010 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require_relative 'container'
require_relative 'style_section'

module RODF
  class DataStyle < Container
    contains :style_sections

    alias section style_section

    def initialize(name, type)
      @type, @name = type, name
    end

    def xml
      Builder::XmlMarkup.new.tag! "number:#{@type}-style", 'style:name' => @name do |xml|
        xml << style_sections_xml
      end
    end

    def method_missing(name, *args)
      section(name, *args)
    end
  end
end
