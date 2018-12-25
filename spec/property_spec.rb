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

require_relative 'spec_helper'

require_relative '../lib/rodf/property'

describe RODF::Property do
  it "should accept either strings or symbols as keys" do
    property = RODF::Property.new :text, color:'#4c4c4c', 'font-weight'=>'bold'
    elem = Hpricot(property.xml).at('style:text-properties')
    elem['fo:color'].should == '#4c4c4c'
    elem['fo:font-weight'].should == 'bold'
  end

  it "should prefix style properties with looked up namespace" do
    Hpricot(RODF::Property.new(:cell, 'rotation-angle' => '-90').xml).
      at('//style:table-cell-properties')['style:rotation-angle'].should == '-90'
    Hpricot(RODF::Property.new(:row, 'row-height' => '2cm').xml).
      at('//style:table-row-properties')['style:row-height'].should == '2cm'
    Hpricot(RODF::Property.new(:column, 'column-width' => '2cm').xml).
      at('//style:table-column-properties')['style:column-width'].should == '2cm'
    Hpricot(RODF::Property.new(:text, 'text-underline-type' => 'single').xml).
      at('style:text-properties')['style:text-underline-type'].should == 'single'
    Hpricot(RODF::Property.new(:paragraph, 'tab-stop-distance' => '0.4925in').xml).
      at('style:paragraph-properties')['style:tab-stop-distance'].should == '0.4925in'
    Hpricot(RODF::Property.new(:page_layout, 'border-line-width' => '2px').xml).
      at('style:page-layout-properties')['style:border-line-width'].should == '2px'
    Hpricot(RODF::Property.new(:header_footer, 'border-line-width' => '2px').xml).
      at('style:header-footer-properties')['style:border-line-width'].should == '2px'
    Hpricot(RODF::Property.new(:ruby, 'ruby-position' => 'above').xml).
      at('style:ruby-properties')['style:ruby-position'].should == 'above'
    Hpricot(RODF::Property.new(:section, 'editable' => true).xml).
      at('style:section-properties')['style:editable'].should == 'true'
    Hpricot(RODF::Property.new(:table, 'align' => 'left').xml).
      at('style:table-properties')['table:align'].should == 'left'
    Hpricot(RODF::Property.new(:list_level, 'space-before' => '2em').xml).
      at('style:list-level-properties')['text:space-before'].should == '2em'
    # style:graphic-properties
    # style:chart-properties
    # style:drawing-page-properties
  end

  it "should generate row properties tag" do
    property = RODF::Property.new :row, 'background-color' => '#f5f57a'

    property.xml.should have_tag('//style:table-row-properties')
  end

  it "should accept full perimeter border specs" do
    property = RODF::Property.new :cell, border: "0.025in solid #000000"

    Hpricot(property.xml).at('//style:table-cell-properties')['fo:border'].
      should == "0.025in solid #000000"
  end

  it "should accept splited full perimeter border specs" do
    property = RODF::Property.new :cell, border_width: '0.025in',
                                        border_color: '#000000',
                                        border_style: 'solid'

    Hpricot(property.xml).at('//style:table-cell-properties')['fo:border'].
      should == "0.025in solid #000000"
  end

  it "should use the first value for vertical and second for horizontal border side specs" do
    property = RODF::Property.new :cell, border_width: '0.025in 0.3in',
                                        border_color: '#ff0000 #0000ff',
                                        border_style: 'solid'

    elem= Hpricot(property.xml).at('//style:table-cell-properties')
    elem['fo:border-top'].should == "0.025in solid #ff0000"
    elem['fo:border-right'].should == "0.3in solid #0000ff"
    elem['fo:border-bottom'].should == "0.025in solid #ff0000"
    elem['fo:border-left'].should == "0.3in solid #0000ff"
  end

  it "should use the third value for bottom border specs when present" do
    property = RODF::Property.new :cell, border_width: '0.025in 0.3in 0.4in',
                                        border_color: '#ff0000 #0000ff',
                                        border_style: 'dotted solid solid'

    elem = Hpricot(property.xml).at('//style:table-cell-properties')
    elem['fo:border-bottom'].should == "0.4in solid #ff0000"

    property = RODF::Property.new :cell, border_width: '0.025in',
                                        border_color: '#ff0000 #0000ff #00ff00',
                                        border_style: 'dotted solid'

    elem = Hpricot(property.xml).at('//style:table-cell-properties')
    elem['fo:border-bottom'].should == "0.025in dotted #00ff00"
  end

  it "should cascade left border specs from fourth to second to first" do
    property = RODF::Property.new :cell, border_width: '0.1in 0.2in 0.3in 0.4in',
                                        border_color: '#ff0000 #0000ff #00ff00',
                                        border_style: 'dotted solid'

    elem = Hpricot(property.xml).at('//style:table-cell-properties')
    elem['fo:border-left'].should == "0.4in solid #0000ff"

    property = RODF::Property.new :cell, border_width: '0.1in 0.2in 0.3in',
                                        border_color: '#ff0000 #0000ff',
                                        border_style: 'dotted'

    elem = Hpricot(property.xml).at('//style:table-cell-properties')
    elem['fo:border-left'].should == "0.2in dotted #0000ff"

    property = RODF::Property.new :cell, border_width: '0.1in 0.2in',
                                        border_color: '#ff0000',
                                        border_style: 'dotted solid dashed double'

    elem = Hpricot(property.xml).at('//style:table-cell-properties')
    elem['fo:border-left'].should == "0.2in double #ff0000"

    property = RODF::Property.new :cell, border_width: '0.1in',
                                        border_color: '#ff0000 #0000ff #00ff00 #ffff00',
                                        border_style: 'dotted solid dashed'

    elem = Hpricot(property.xml).at('//style:table-cell-properties')
    elem['fo:border-left'].should == "0.1in solid #ffff00"
  end

  it "should support paragraph properties" do
    RODF::Property.new(:paragraph).xml.
      should have_tag('style:paragraph-properties')
  end

  it "should know the namespace for style:text-properties style properties" do
    #see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#__RefHeading__1416402_253892949
    ['country-asian', 'country-complex', 'font-charset', 'font-charset-asian',
     'font-charset-complex', 'font-family-asian', 'font-family-complex', 'font-family-generic',
     'font-family-generic-asian', 'font-family-generic-complex', 'font-name', 'font-name-asian',
     'font-name-complex', 'font-pitch', 'font-pitch-asian', 'font-pitch-complex', 'font-relief',
     'font-size-asian', 'font-size-complex', 'font-size-rel', 'font-size-rel-asian',
     'font-size-rel-complex', 'font-style-asian', 'font-style-complex', 'font-style-name',
     'font-style-name-asian', 'font-style-name-complex', 'font-weight-asian', 'font-weight-complex',
     'language-asian', 'language-complex', 'letter-kerning', 'rfc-language-tag',
     'rfc-language-tag-asian', 'rfc-language-tag-complex', 'script-asian', 'script-complex',
     'script-type', 'text-blinking', 'text-combine', 'text-combine-end-char',
     'text-combine-start-char', 'text-emphasize', 'text-line-through-color',
     'text-line-through-mode', 'text-line-through-style', 'text-line-through-text',
     'text-line-through-text-style', 'text-line-through-type', 'text-line-through-width',
     'text-outline', 'text-overline-color', 'text-overline-mode', 'text-overline-style',
     'text-overline-type', 'text-overline-width', 'text-position', 'text-rotation-angle',
     'text-rotation-scale', 'text-scale', 'text-underline-color', 'text-underline-mode',
     'text-underline-style', 'text-underline-type', 'text-underline-width', 'use-window-font-color'].
    each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
  end

  it "should know the namespace for style:table-cell-properties style properties" do
    #see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#__RefHeading__1416518_253892949
    ['border-line-width', 'border-line-width-bottom', 'border-line-width-left',
     'border-line-width-right', 'border-line-width-top', 'cell-protect', 'decimal-places',
     'diagonal-bl-tr', 'diagonal-bl-tr-widths', 'diagonal-tl-br', 'diagonal-tl-br-widths',
     'direction', 'glyph-orientation-vertical', 'print-content', 'repeat-content',
     'rotation-align', 'rotation-angle', 'shadow', 'shrink-to-fit', 'text-align-source',
     'vertical-align', 'writing-mode'].
    each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
  end

  it "should know the namespace for style:table-cell-properties style properties" do
    #see http://docs.oasis-open.org/office/v1.2/os/opendocument-v1.2-os-part1.html#__refheading__1416516_253892949
    ['min-row-height', 'row-height', 'use-optimal-row-height'].each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
  end

  it "should know the namespace for style:table-row-properties style properties" do
    # see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#__RefHeading__1416514_253892949
    ['column-width', 'rel-column-width', 'use-optimal-column-width'].each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
  end

  it "should know the namespace for style:paragraph-properties style properties" do
    # see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#__RefHeading__1416494_253892949
    ['auto-text-indent', 'background-transparency', 'border-line-width', 'border-line-width-bottom',
     'border-line-width-left', 'border-line-width-right', 'border-line-width-top',
     'font-independent-line-spacing', 'join-border', 'justify-single-word', 'line-break',
     'line-height-at-least', 'line-spacing', 'page-number', 'punctuation-wrap', 'register-true',
     'shadow', 'snap-to-layout-grid', 'tab-stop-distance', 'text-autospace', 'vertical-align',
     'writing-mode', 'writing-mode-automatic'].
    each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
  end

  it "should know the namespace for style:page-layout-properties style properties" do
    # see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#__RefHeading__1416486_253892949
    ['border-line-width', 'border-line-width-bottom', 'border-line-width-left', 'border-line-width-right',
     'border-line-width-top', 'first-page-number', 'footnote-max-height', 'layout-grid-base-height',
     'layout-grid-base-width', 'layout-grid-color', 'layout-grid-display', 'layout-grid-lines',
     'layout-grid-mode', 'layout-grid-print', 'layout-grid-ruby-below', 'layout-grid-ruby-height',
     'layout-grid-snap-to', 'layout-grid-standard-mode', 'num-format', 'num-letter-sync',
     'num-prefix', 'num-suffix', 'paper-tray-name', 'print', 'print-orientation', 'print-page-order',
     'register-truth-ref-style-name', 'scale-to', 'scale-to-pages', 'shadow', 'table-centering',
     'writing-mode'].
    each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
  end

  it "should know the namespace for style:header-footer-properties style and svg properties" do
    # see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#__RefHeading__1416492_253892949
    ['border-line-width', 'border-line-width-bottom', 'border-line-width-left', 'border-line-width-right',
     'border-line-width-top', 'dynamic-spacing', 'shadow'].
    each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
    RODF::Property.lookup_namespace_for('height').should == 'svg'
  end

  it "should know the namespace for style:ruby-properties style properties" do
    # see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#__RefHeading__1416502_253892949
    ['ruby-align', 'ruby-position'].each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
  end

  it "should know the namespace for style:section-properties style and text properties" do
    # see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#element-style_section-properties
    ['editable', 'protect', 'writing-mode'].each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
    RODF::Property.lookup_namespace_for('dont-balance-text-columns').should == 'text'
  end

  it "should know the namespace for style:table-properties style and table properties" do
    # see http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html#element-style_table-properties
    ['may-break-between-rows', 'page-number', 'rel-width', 'shadow', 'width', 'writing-mode'].
    each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
    ['align', 'border-model', 'display'].each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'table'
    end
  end

  it "should know the namespace for style:list-level-properties style, svg and text properties" do
    ['font-name', 'vertical-pos', 'vertical-rel'].each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'style'
    end
    RODF::Property.lookup_namespace_for('y').should == 'svg'
    ['list-level-position-and-space-mode', 'min-label-distance', 'min-label-width',
     'space-before'].
    each do |prop|
      RODF::Property.lookup_namespace_for(prop).should == 'text'
    end
  end
end

