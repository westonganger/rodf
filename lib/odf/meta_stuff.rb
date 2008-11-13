module ODF
  def self.container_of(stuffs)
    container_class = Class.new

    stuff = stuffs.to_s[0..-2]
    stuff_class = eval(stuff.capitalize)

    def container_class.create(*args)
      container = new(*args)
      yield container if block_given?
      container.xml
    end

    container_class.send :define_method, :children do
      @children ||= []
    end

    container_class.send :define_method, stuff do |*args|
      c = stuff_class.new(*args)
      yield c if block_given?
      children << c
      c
    end

    container_class.send :define_method, :children_xml do
      children.map {|c| c.xml}.join
    end

    container_class
  end
end

