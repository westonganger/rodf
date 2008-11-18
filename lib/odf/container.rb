# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# Foobar is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

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

