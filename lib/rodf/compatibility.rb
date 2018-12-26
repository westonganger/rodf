# Copyright (c) 2010-2012 Thiago Arrais
#
# This file is part of rODF.

require 'builder'

if !String.method_defined? :to_xs
  class String
    def to_xs
      Builder::XChar.encode(self)
    end
  end
end
