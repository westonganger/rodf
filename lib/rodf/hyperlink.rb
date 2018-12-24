# Copyright (c) 2010 Thiago Arrais
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

require 'builder'

require 'rodf/paragraph_container'

module RODF
  class Hyperlink < ParagraphContainer
    def initialize(first, second = {})
      if second.instance_of?(Hash) && second.empty?
        @href = first
      else
        span(first)
        @href = second.instance_of?(Hash) ? second[:href] : second
      end
    end

    def xml
      Builder::XmlMarkup.new.text:a, 'xlink:href' => @href do |a|
        a << content_parts_xml
      end
    end
  end

  class ParagraphContainer < Container
    def link(*args)
      l = Hyperlink.new(*args)
      yield l if block_given?
      content_parts << l
      l
    end
    alias a link
  end
end
