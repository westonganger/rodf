require 'builder'

if !String.method_defined? :to_xs
  class String
    def to_xs
      Builder::XChar.encode(self)
    end
  end
end
