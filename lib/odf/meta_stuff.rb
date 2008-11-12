module ODF
  def self.container_of(stuffs)
    container_class = Class.new

    stuff = stuffs.to_s[0..-2]
    stuff_class = eval(stuff.capitalize)

    def container_class.create(*args)
      container = new(*args)
      yield container if block_given?
      container.content
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

    container_class.send :define_method, :children_content do |*args|
      children.map {|c| c.content}.join
    end

    container_class
  end
end

