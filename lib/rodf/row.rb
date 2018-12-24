# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require_relative 'container'
require_relative 'cell'

module RODF
  class Row < Container
    contains :cells
    attr_reader :number
    attr_writer :style

    def initialize(number=0, opts={})
      @number = number
      @style = opts[:style]

      super
    end

    def xml
      elem_attrs = {}
      elem_attrs['table:style-name'] = @style unless @style.nil?
      Builder::XmlMarkup.new.tag! 'table:table-row', elem_attrs do |xml|
        xml << cells_xml
      end
    end
  end
end
