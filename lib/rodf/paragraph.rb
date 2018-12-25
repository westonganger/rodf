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

require_relative 'paragraph_container'

module RODF
  class Paragraph < ParagraphContainer
    def initialize(fst = nil, snd = {})
      first_is_hash = fst.instance_of? Hash
      span(fst) unless first_is_hash
      @elem_attrs = make_element_attributes(first_is_hash ? fst : snd)
    end

    def xml
      Builder::XmlMarkup.new.text:p, @elem_attrs do |xml|
        xml << content_parts_xml
      end
    end

  private

    def make_element_attributes(opts)
      attrs = {}
      attrs['text:style-name'] = opts[:style] unless opts[:style].nil?
      attrs
    end

  end
end
