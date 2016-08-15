# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.
#
# rODF is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.

# rODF is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.

# You should have received a copy of the GNU Lesser General Public License
# along with rODF.  If not, see <http://www.gnu.org/licenses/>.

require 'rubygems'
gem 'activesupport', '>= 3.0', '< 6.0'

require 'active_support/inflector'

module ODF
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

