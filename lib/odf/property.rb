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
        width = tspecs[:border_width].split
        style = tspecs[:border_style].split
        color = tspecs[:border_color].split
        if width.length == 1 && style.length == 1 && color.length == 1 then
          result[:border] = [width[0], style[0], color[0]].join(' ')
        else
          result['border-top'] = cascading_join(width, style, color, 0)
          result['border-right'] = cascading_join(width, style, color, 1, 0)
          result['border-bottom'] = cascading_join(width, style, color, 2, 0)
          result['border-left'] = cascading_join(width, style, color, 3, 1, 0)
        end
      end
      result
    end

    def cascading_join(width_parts, style_parts, color_parts, *prefs)
      [ cascade(width_parts, prefs),
        cascade(style_parts, prefs),
        cascade(color_parts, prefs)].join(' ')
    end

    def cascade(list, prefs)
      prefs.inject(nil) {|acc, i| acc || list[i]}
    end
  end
end

