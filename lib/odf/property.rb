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
require 'builder'

module ODF
  class Property
    PROPERTY_NAMES = {:cell => 'style:table-cell-properties',
                      :text => 'style:text-properties',
                      :column => 'style:table-column-properties'}
    TRANSLATED_SPECS = [:border_color, :border_style, :border_width]

    def initialize(type, specs={})
      @name = PROPERTY_NAMES[type]
      @specs = translate(specs).map { |k, v| [k.to_s, v] }
    end

    def xml
      specs = @specs.inject({}) do |acc, kv|
        prefix = 'column-width' == kv.first ? 'style' : 'fo'
        acc.merge prefix + ':' + kv.first => kv.last
      end
      Builder::XmlMarkup.new.tag! @name, specs
    end
  private
    def translate(specs)
      result = specs.clone
      tspecs = specs.select {|k, v| TRANSLATED_SPECS.include? k}
      tspecs.map {|k, v| result.delete k}
      tspecs = tspecs.inject({}) {|acc, e| acc.merge e.first => e.last}
      if tspecs[:border_width] && tspecs[:border_style] && tspecs[:border_color] then
        width_parts = tspecs[:border_width].split
        style_parts = tspecs[:border_style].split
        color_parts = tspecs[:border_color].split
        if  width_parts.length == 1 &&
            style_parts.length == 1 &&
            color_parts.length == 1 then
          result[:border] = [width_parts[0], style_parts[0], color_parts[0]].join(' ')
        else
          result['border-top'] = [width_parts[0], style_parts[0], color_parts[0]].join(' ')
          result['border-right'] = [  width_parts[1] || width_parts[0],
                                      style_parts[1] || style_parts[0],
                                      color_parts[1] || color_parts[0]].join(' ')
          result['border-bottom'] = [ width_parts[2] || width_parts[0],
                                      style_parts[2] || style_parts[0],
                                      color_parts[2] || color_parts[0]].join(' ')
          result['border-left'] = [ width_parts[1] || width_parts[0],
                                    style_parts[1] || style_parts[0],
                                    color_parts[1] || color_parts[0]].join(' ')
        end
      end
      result
    end
  end
end

