module RODF
  class Container
    def initialize(*_args, &contents)
      return unless contents

      if contents.arity.zero?
        instance_exec(self, &contents)
      else
        yield(self)
      end
    end

    def self.create(*args, &contents)
      container = new(*args, &contents)
      container.xml
    end
  end
end
