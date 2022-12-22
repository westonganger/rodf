# RODF
<a href="https://badge.fury.io/rb/rodf" target="_blank"><img height="21" style='border:0px;height:21px;' border='0' src="https://badge.fury.io/rb/rodf.svg" alt="Gem Version"></a>
<a href='https://github.com/westonganger/rodf/actions' target='_blank'><img src="https://github.com/westonganger/rodf/workflows/Tests/badge.svg" style="max-width:100%;" height='21' style='border:0px;height:21px;' border='0' alt="CI Status"></a>
<a href='https://rubygems.org/gems/rodf' target='_blank'><img height='21' style='border:0px;height:21px;' src='https://img.shields.io/gem/dt/rodf?color=brightgreen&label=Rubygems%20Downloads' border='0' alt='RubyGems Downloads' /></a>
<a href='https://ko-fi.com/A5071NK' target='_blank'><img height='22' style='border:0px;height:22px;' src='https://az743702.vo.msecnd.net/cdn/kofi1.png?v=a' border='0' alt='Buy Me a Coffee' /></a>

RODF is a library for writing to ODF output from Ruby. It mainly focuses creating ODS spreadsheets.

As well as writing ODS spreadsheets, this library also can write ODT text documents but it is undocumented and will require knowledge of the ODF spec. It currently does not support ODP Slide shows. Also this is NOT an ODF reading library.

## Install

```
gem install rodf
```

## Usage

RODF works pretty much like Builder, but with ODF-aware constructs. For example:

```ruby
RODF::Spreadsheet.file("my-spreadsheet.ods") do
  table 'My first table from Ruby' do
    row do
      cell 'Hello world!'
    end
  end
end
```

For access to variables and methods from outer code you can use block parameter:

```ruby
@data = 'Hello world!'

RODF::Spreadsheet.file("my-spreadsheet.ods") do |sheet|
  sheet.table 'My first table from Ruby' do |table|
    table.row do |row|
      row.cell @data
    end
  end
end
```

Adding many rows or cells at once is supported as well:

```ruby
RODF::Spreadsheet.file("my-spreadsheet.ods") do |sheet|
  sheet.table 'My first table from Ruby' do |t|
    t.add_rows([
      [1, 'Alice'],
      [2, { value: 'Bob', color: '#ff0000'}],
      [3, 'Carol']
    ])

    t.row do |r|
      r.add_cells ['ID', 'Name']
    end
  end
end
```

## Procedural style

The declarative style shown above is just syntatic sugar. A more procedural style can also be used. Like so:

```ruby
ss = RODF::Spreadsheet.new

t = ss.table 'My first table from Ruby'
r = t.row
c = r.cell 'Hello world!'

# two methods to write to file
ss.write_to 'my-spreadsheet.ods'
# or
File.write('my-spreadsheet.ods', ss.bytes) # you can send your data in Rails over HTTP using the bytes method
```

Both styles can be mixed and matched at will:

```ruby
ss = RODF::Spreadsheet.new

ss.table 'My first table from Ruby' do |t|
  t.row do |r|
    r.cell 'Hello world!'
  end
end

ss.write_to 'my-spreadsheet.ods'
```

## Styling and Formatting

```ruby
RODF::Spreadsheet.file("my-spreadsheet.ods") do |sheet|

  sheet.style 'red-cell', family: :cell do |s|
    s.property :text, 'font-weight' => 'bold', 'color' => '#ff0000'
  end

  sheet.style 'row-height', family: :row do |s|
    s.property :row, 'row-height' => '18pt', 'use-optimal-row-height' => 'true'
  end

  sheet.table 'Red text table' do |t|
    t.row style: 'row-height' do |r|
      r.cell 'Red', style: 'red-cell'
    end
  end

  sheet.table 'Text with Paragraphs' do |t|
    t.row style: 'row-height' do |r|
      r.cell do |cell|
        cell.paragraph do |paragraph|
          text_array = my_text_content.split("\n").select{|x| !x.empty? }

          text_array.each do |str|
            if str.start_with?("#")
              paragraph.span(str, style: 'red-cell')
            else
              paragraph.span(str)
            end
          end
        end
      end
    end
  end

end
```

Conditional formatting is also possible:

```ruby
RODF::Spreadsheet.file("my-spreadsheet.ods") do |sheet|

  sheet.office_style 'red-cell', family: :cell do |s|
    s.property :text, 'font-weight' => 'bold', 'color' => '#ff0000'
  end

  sheet.office_style 'green-cell', family: :cell do |s|
    s.property :text, 'font-weight' => 'bold', 'color' => '#00ff00'
  end

  # conditional formating must be defined as style and the value of
  # apply-style-name must be an office_style
  sheet.style 'cond1', family: :cell do |s|
    s.property :conditional, 'condition' => 'cell-content()<0', 'apply-style-name' => 'red-cell'

    s.property :conditional, 'condition' => 'cell-content()>0', 'apply-style-name' => 'green-cell'
  end

  sheet.table 'Red text table' do |t|
    t.row do |r|
      r.cell 'Red force', style: 'red-cell'
    end
    t.row do |r|
      r.cell '-4', type: :float, style: 'cond1'
    end
    t.row do |r|
      r.cell '0', type: :float, style: 'cond1'
    end
    t.row do |r|
      r.cell '5', type: :float, style: 'cond1'
    end
  end
end
```

## Changing Columns Widths

Adding columns or columns width to your spreadsheet can be done with the following

```ruby
RODF::Spreadsheet.file("my-spreadsheet.ods") do |sheet|
  sheet.table "foo" do |t|
    sheet.style('default-col-width', family: :column) do |s|
      s.property(:column, 'column-width' => '1.234in')
    end

    col_count.times do
      t.column style: 'default-col-width'
    end

    ### OR

    ### Warning this will overwrite any existing table columns (cells remain unaffected)
    sheet.set_column_widths(
      table: t, 
      column_widths: [
        {'column-width' => '1in'},
        {'column-width' => '2cm'},
        {'column-width' => '2.54cm'},
      ],
    )
  end
end
```

## Columns Types

Available columns types are:

- :string
- :float
- :date
- :time
- :currency
- :percentage

## Style List
```ruby
### family: :cell or "table-cell"
style "my-cell-style", family: :cell do
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
    'writing-mode' => 'lr-tb',

end

### family: :column or "table-column"
style('my-col-style', family: :column) do
  property :column,
    'column-width' => '4.0cm'
end

### family: :row or "table-row"
style('my-row-style', family: :row) do
  property :row,
    'row-height' => '18pt',
    'use-optimal-row-height' => 'true'
end

### family: :table
style('my-row-style', family: :table) do
  property :table,
    'writing-mode' => 'lr-tb',
```

## Adding Arbitrary XML Attributes

```ruby
RODF::Spreadsheet.file("my-spreadsheet.ods") do |sheet|
  sheet.table 'My first table from Ruby', attributes: {'table-protected' => 'true'} do |table|
    table.row do |row|
      row.cell @data
    end
  end
end

```

## Production Usage Examples

- `spreadsheet_architect` gem - [View Relevant Source Code](https://github.com/westonganger/spreadsheet_architect/blob/master/lib/spreadsheet_architect/class_methods/ods.rb)

## Credits

Originally Created by [@thiagoarrais](https://github.com/thiagoarrais)

Maintained by [@westonganger](https://github.com/westonganger) since 2016, for simplified ODS spreadsheet creation within the [spreadsheet_architect](https://github.com/westonganger/spreadsheet_architect) gem
