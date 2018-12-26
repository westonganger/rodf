# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.

require 'active_support/inflector'

module RODF
  class Container
    def self.contains(*stuffs_array)
      stuffs_array.map {|sym| sym.to_s}.each do |stuffs|
        stuff = stuffs.to_s.singularize
        stuff_class = RODF.const_get(stuff.camelize)

        define_method stuffs do
          instance_variable_name = :"@#{stuffs}"

          if instance_variable_defined?(instance_variable_name)
            return instance_variable_get(instance_variable_name)
          end

          instance_variable_set(instance_variable_name, [])
        end

        define_method stuff do |*args, &contents|
          c = stuff_class.new(*args)
          c.instance_exec(c, &contents) if contents
          public_send(stuffs) << c
          c
        end

        define_method "#{stuffs}_xml" do
          public_send(stuffs).map(&:xml).join
        end
      end
    end

    def self.create(*args, &contents)
      container = new(*args)
      container.instance_exec(container, &contents) if contents
      container.xml
    end
  end
end
