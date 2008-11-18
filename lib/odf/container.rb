require 'rubygems'
require 'active_support/core_ext/string'

module ODF
  class Container
    def self.contains(*stuffs_array)
      stuffs_array.map {|sym| sym.to_s}.each do |stuffs|
        stuff = stuffs.to_s.singularize
        stuff_class = eval(stuff.capitalize)

        self.class_eval "
          def #{stuffs}
            @#{stuffs} ||= []
          end"

        self.class_eval "
          def #{stuff}(*args)
            c = #{stuff_class}.new(*args)
            yield c if block_given?
            #{stuffs} << c
            c
          end"

        self.class_eval "
          def #{stuffs}_xml
            #{stuffs}.map {|c| c.xml}.join
          end"
      end
    end

    def self.create(*args)
      container = self.new(*args)
      yield container if block_given?
      container.xml
    end
  end
end

