<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='32' style='border:0px;height:32px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee' /></a> 
# RODF

This is a library for writing to ODF output from Ruby. It mainly focuses creating ODS spreadsheets.

As well as writing ODS spreadsheets, this library also can write ODT text documents but it is undocumented and will require knowledge of the ODF spec. It currently does not support ODP Slide shows.

This is NOT an ODF reading library.

### v1.0.0 Breaking Changes
The main module `ODF` has changed to `RODF`

`require 'odf/spreadsheet'` must be changed to `require 'rodf'`

### Install

```
gem install rodf
```

### How do I use it?

rODF works pretty much like Builder, but with ODF-aware constructs. Try this:

```ruby
require 'rodf'

RODF::Spreadsheet.file("my-spreadsheet.ods") do
  table 'My first table from Ruby' do
    row do
      cell 'Hello, rODF world!'
    end
  end
end
```

Styling and formatting is also possible:

```ruby
require 'rodf'

RODF::Spreadsheet.file("my-spreadsheet.ods") do
  style 'red-cell', family: :cell do
    property :text, 'font-weight' => 'bold', 'color' => '#ff0000'
  end

  table 'Red text table' do
    row do
      cell 'Red', style: 'red-cell'
    end
  end
end
```

Conditional formatting is also possible:

```ruby
require 'rodf'

RODF::Spreadsheet.file("my-spreadsheet.ods") do

  office_style 'red-cell', family: :cell do
    property :text, 'font-weight' => 'bold', 'color' => '#ff0000'
  end

  office_style 'green-cell', family: :cell do
    property :text, 'font-weight' => 'bold', 'color' => '#00ff00'
  end

  # conditional formating must be defined as style and the value of
  # apply-style-name must be an office_style
  style 'cond1', family: :cell do
    property :conditional, 'condition' => 'cell-content()<0', 'apply-style-name' => 'red-cell'

    property :conditional, 'condition' => 'cell-content()>0', 'apply-style-name' => 'green-cell'
  end

  table 'Red text table' do
    row do
      cell 'Red force', style: 'red-cell'
    end
    row do
      cell '-4', type: :float, style: 'cond1'
    end
    row do
      cell '0', type: :float, style: 'cond1'
    end
    row do
      cell '5', type: :float, style: 'cond1'
    end
  end
end
```

### Procedural style

The declarative style shown above is just syntatic sugar. A more procedural
style can also be used. Like so:

```ruby
require 'rodf'

ss = RODF::Spreadsheet.new
t = ss.table 'My first table from Ruby'
r = t.row
c = r.cell 'Hello, rODF world!'

# two methods to write to file
ss.write_to 'my-spreadsheet.ods'
# or
File.write('my-spreadsheet.ods') do |f|
  f.write ss.bytes # you can send your data in Rails over HTTP using the bytes method
end
```

Both styles can be mixed and matched at will:

```ruby
require 'rodf'

ss = RODF::Spreadsheet.new
ss.table 'My first table from Ruby' do
  row do
    cell 'Hello, rODF world!'
  end
end

ss.write_to 'my-spreadsheet.ods'
```

### Style List
```ruby
property :text, 
  'font-weight' => :bold, #options are :bold, :thin
  'font-size' => 12,
  'font-name' => 'Arial',
  'font-style' => 'italic',
  'text-underline-style' => 'solid', # solid, dashed, dotted, double
  'text-underline-type' => 'single',
  'text-line-through-style' => 'solid',
  align: true,
  color: "#000000"

property :cell, 
  'background-color' => "#DDDDDD",
  'wrap-option' => 'wrap',
  'vertical_align' => 'automatic',
  'border-top' => '0.75pt solid #999999',
  'border-bottom' => '0.75pt solid #999999',
  'border-left' => '0.75pt solid #999999',
  'border-right' => '0.75pt solid #999999',

property :column, 
  'column-width' => '4.0cm'

property :row, 
  'row-height' => '18pt',
  'use-optimal-row-height' => 'true'

property :table,
  'writing-mode' => 'lr-tb',
```


### Credits
Created by [@thiagoarrais](https://github.com/thiagoarrais)

Currently maintained by [@westonganger](https://github.com/westonganger) to support simplified ODS spreadsheet making in the [spreadsheet_architect](https://github.com/westonganger/spreadsheet_architect) gem

<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='32' style='border:0px;height:32px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee' /></a> 
