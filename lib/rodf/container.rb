# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.

require 'active_support/inflector'

module RODF
  class Container
    def self.contains(*stuffs_array)
      stuffs_array.map {|sym| sym.to_s}.each do |stuffs|
        stuff = stuffs.to_s.singularize
        stuff_class = eval(stuff.camelize)

        self.class_eval "
          def #{stuffs}
            @#{stuffs} ||= []
          end"

        self.class_eval "
          def #{stuff}(*args, &contents)
            c = #{stuff_class}.new(*args)
            c.instance_eval(&contents) if block_given?
            #{stuffs} << c
            c
          end"

        self.class_eval "
          def #{stuffs}_xml
            #{stuffs}.map {|c| c.xml}.join
          end"
      end
    end

    def self.create(*args, &contents)
      container = self.new(*args)
      container.instance_eval(&contents) if block_given?
      container.xml
    end
  end
end
