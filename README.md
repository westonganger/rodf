# rODF

This is a library for writing to ODF output from Ruby. It currently only
supports creating spreadsheets (ODS) and text documents (ODT). Slide shows (ODP)
may be added some time in the future.

Some knowledge of the [ODF spec](http://docs.oasis-open.org/office/v1.2/os/OpenDocument-v1.2-os-part1.html) is required.

This is NOT an ODF reading library.

### v1.0.0 Breaking Changes
The main module ODF has been renamed to RODF. This has resulted in a change in the way to require rodf. 
`require 'odf/spreadsheet'` must be changed to `require 'rodf'`

### Installation

You should be able to install the latest stable version by saying something like

    gem install rodf

### How do I use it?

rODF works pretty much like Builder, but with ODF-aware constructs. Try this:

    require 'rodf'

    RODF::Spreadsheet.file("my-spreadsheet.ods") do
      table 'My first table from Ruby' do
        row {cell 'Hello, rODF world!' }
      end
    end

Some basic formatting is also possible:

    require 'rodf'

    RODF::Spreadsheet.file("my-spreadsheet.ods") do
      style 'red-cell', :family => :cell do
        property :text, 'font-weight' => 'bold', 'color' => '#ff0000'
      end
      table 'Red text table' do
        row {cell 'Red', :style => 'red-cell' }
      end
    end

Some basic conditional formatting is also possible:

    require 'rodf'

    RODF::Spreadsheet.file("my-spreadsheet.ods") do

      office_style 'red-cell', :family => :cell do
        property :text, 'font-weight' => 'bold', 'color' => '#ff0000'
      end

      office_style 'green-cell', :family => :cell do
        property :text, 'font-weight' => 'bold', 'color' => '#00ff00'
      end

      # conditional formating must be defined as style and the value of
      # apply-style-name must be an office_style
      style 'cond1', :family => :cell do

        property :conditional,
                  'condition' => 'cell-content()<0',
                  'apply-style-name' => 'red-cell'

        property :conditional,
                  'condition' => 'cell-content()>0',
                  'apply-style-name' => 'green-cell'
      end

      table 'Red text table' do
        row {cell 'Red force', :style => 'red-cell' }
        row {cell '-4', :type => :float, :style => 'cond1' }
        row {cell '0', :type => :float, :style => 'cond1' }
        row {cell '5', :type => :float, :style => 'cond1' }
      end
    end

### Procedural style

The declarative style shown above is just syntatic sugar. A more procedural
style can also be used. Like so:

    require 'rodf'

    ss = RODF::Spreadsheet.new
    t = ss.table 'My first table from Ruby'
    r = t.row
    c = r.cell 'Hello, rODF world!'

    ss.write_to 'my-spreadsheet.ods'

Both styles can be mixed and matched at will:

    require 'rodf'

    ss = RODF::Spreadsheet.new
    ss.table 'My first table from Ruby' do
      row { cell 'Hello, rODF world!' }
    end

    ss.write_to 'my-spreadsheet.ods'
