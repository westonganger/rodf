# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

require 'rodf/column'
require 'rodf/container'
require 'rodf/row'

module RODF
  class Table < Container
    contains :rows, :columns

    def initialize(title)
      @title = title
      @last_row = 0
    end

    alias create_row row
    def row(options={}, &contents)
      create_row(next_row, options) {instance_eval(&contents) if block_given?}
    end

    def xml
      Builder::XmlMarkup.new.table:table, 'table:name' => @title do |xml|
        xml << columns_xml
        xml << rows_xml
      end
    end
  private
    def next_row
      @last_row += 1
    end
  end
end
