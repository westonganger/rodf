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
require 'builder'

module ODF
  class Property
    PROPERTY_NAMES = {:cell => 'style:table-cell-properties',
                      :text => 'style:text-properties'}

    def initialize(type, specs={})
      @name = PROPERTY_NAMES[type]
      @specs = specs.map { |k, v| [k.to_s, v] }
    end

    def xml
      specs = {}
      @specs.each do |k, v|
        specs['fo:' + k] = v
      end
      Builder::XmlMarkup.new.tag! @name, specs
    end
  end
end

