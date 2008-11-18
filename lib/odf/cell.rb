require 'rubygems'
require 'builder'

module ODF
  class Cell
    def initialize(*args)
      value = args.first || ''
      opts = args.last.instance_of?(Hash) ? args.last : {}

      @type = opts[:type] || :string
      @formula = opts[:formula]
      @style = opts[:style]
      @value = value.to_s.strip unless value.instance_of? Hash
    end

    def xml
      elem_attrs = {'office:value-type' => @type}
      elem_attrs['office:value'] = @value unless contains_string?
      elem_attrs['table:formula'] = @formula unless @formula.nil?
      elem_attrs['table:style-name'] = @style unless @style.nil?

      Builder::XmlMarkup.new.tag! 'table:table-cell', elem_attrs do |xml|
        xml.text(:p, @value) if contains_string?
      end
    end

    def contains_string?
      :string == @type && !@value.nil? && !@value.empty?
    end
  end
end

