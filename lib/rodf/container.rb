# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.

require 'dry/inflector'

module RODF
  class Container
    INFLECTOR = Dry::Inflector.new.freeze

    def self.contains(*stuffs_array)
      stuffs_array.map {|sym| sym.to_s}.each do |stuffs|
        stuff = INFLECTOR.singularize(stuffs.to_s)
        stuff_class = RODF.const_get(INFLECTOR.camelize(stuff))

        define_method stuffs do
          instance_variable_name = :"@#{stuffs}"

          if instance_variable_defined?(instance_variable_name)
            return instance_variable_get(instance_variable_name)
          end

          instance_variable_set(instance_variable_name, [])
        end

        define_method stuff do |*args, &contents|
          c = stuff_class.new(*args, &contents)
          public_send(stuffs) << c
          c
        end

        define_method "#{stuffs}_xml" do
          public_send(stuffs).map(&:xml).join
        end
      end
    end

    def self.create(*args, &contents)
      container = new(*args, &contents)
      container.xml
    end

    def initialize(*_args, &contents)
      return unless contents

      if contents.arity.zero?
        instance_exec(self, &contents)
      else
        yield(self)
      end
    end
  end
end
