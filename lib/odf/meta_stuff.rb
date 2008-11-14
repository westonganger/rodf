module ODF
  def self.container_of(*stuffs_array)
    container_class = Class.new

    def container_class.create(*args)
      container = new(*args)
      yield container if block_given?
      container.xml
    end

    stuffs_array.map {|sym| sym.to_s}.each do |stuffs|
      stuff = stuffs.to_s[0..-2]
      stuff_class = eval(stuff.capitalize)

      container_class.class_eval "
        def #{stuffs}
          @#{stuffs} ||= []
        end"

      container_class.class_eval "
        def #{stuff}(*args)
          c = #{stuff_class}.new(*args)
          yield c if block_given?
          #{stuffs} << c
          c
        end"

      container_class.class_eval "
        def #{stuffs}_xml
          #{stuffs}.map {|c| c.xml}.join
        end"
    end

    container_class
  end
end

