require_relative 'spec_helper'

describe RODF::SpreadSheet do
  it "should have the expected structure" do
    output = RODF::SpreadSheet.create {|s| }
    output.should have_tag('//office:document-content/*')
    output.should have_tag('//office:body/*')
    output.should have_tag('//office:spreadsheet')
  end

  it "should be empty if no tables were added" do
    output = RODF::SpreadSheet.create {|s| }
    output.should_not have_tag('//office:spreadsheet/*')
  end

  it "should include tables when asked to" do
    output = RODF::SpreadSheet.create { |s|
      s.table 'Example'
    }
    output.should have_tag('//office:spreadsheet/*', count: 1)
    output.should have_tag('//table:table', count: 1)
    Hpricot(output).at('//table:table')['table:name'].should == 'Example'

    output = RODF::SpreadSheet.create { |s|
      s.table 'First table'
      s.table 'Second table'
    }
    output.should have_tag('//office:spreadsheet/*', count: 2)
  end

  it "should allow tables without name" do
    output = RODF::SpreadSheet.create { |s|
      s.table
    }
    output.should have_tag('//office:spreadsheet/*', count: 1)
    output.should have_tag('//table:table', count: 1)
    Hpricot(output).at('//table:table')['table:name'].should be_empty
  end

  it "should allow rows to be added inside tables" do
    output = RODF::SpreadSheet.create do |s|
      s.table('My table') do |t|
        t.row
      end
    end

    output.should have_tag('//table:table/*')
    output.should have_tag('//table:table-row')
  end

  it "should allow styles to be added" do
    RODF::SpreadSheet.create.should_not have_tag('//office:automatic-styles')
    output = RODF::SpreadSheet.create do |s|
      s.style 'even-row-cell', family: :cell
    end

    output.should have_tag('//office:automatic-styles/*', count: 1)
    output.should have_tag('//style:style')
    Hpricot(output).at('//style:style')['style:name'].should == 'even-row-cell'
    Hpricot(output).at('//style:style')['style:family'].should == 'table-cell'
  end

  it "should have data styles" do
    output = RODF::SpreadSheet.create do |ss|
      ss.data_style 'year-to-day-long', :date
    end
    output.should have_tag('//office:automatic-styles/*', count: 1)
    output.should have_tag('//number:date-style')
  end

  it "should allow conditional styles to be added" do
    output = RODF::SpreadSheet.create do |s|
      s.style 'cond-cell', family: :cell do
        property :conditional,
        'condition' => 'cell-content()!=0',
        'apply-style-name' => 'red-cell'
      end
    end

    output.should have_tag('//style:map')
    Hpricot(output).at('//style:map')['style:apply-style-name'].should == 'red-cell'
  end

  it "should allow office styles to be added" do
    spread = RODF::SpreadSheet.new
    spread.office_style 'red-cell', family: :cell

    output = spread.office_styles_xml

    output.should have_tag('//style:style')
    Hpricot(output).at('//style:style')['style:name'].should == 'red-cell'
    spread.xml.should_not have_tag('//style:style')
  end

  it "should support mixed office and conditional styles to be added" do
    spread = RODF::SpreadSheet.new
    spread.office_style 'red-cell', family: :cell
    spread.style 'cond-cell', family: :cell do
      property :conditional,
      'condition' => 'cell-content()!=0',
      'apply-style-name' => 'red-cell'
    end

    output = spread.styles_xml
    output.should have_tag('//style:map')
    Hpricot(output).at('//style:map')['style:apply-style-name'].should == 'red-cell'

    output = spread.office_styles_xml
    output.should have_tag('//style:style')
    Hpricot(output).at('//style:style')['style:name'].should == 'red-cell'
  end

  it "should allow setting columns and widths in batch using `set_column_widths`" do
    RODF::Spreadsheet.new do |sheet|
      ### WITH SPLAT ARGUMENT
      table = sheet.table do |t|
        sheet.set_column_widths(
          table: t,
          column_widths: [
            '1in',
            '2cm',
            '2.54cm',
          ]
        )
      end

      table.xml.should have_tag('table:table-column')

      column = Hpricot(table.xml).search('table:table-column')[0]
      column['table:style-name'].should == ('col-width-0')

      column = Hpricot(table.xml).search('table:table-column')[1]
      column['table:style-name'].should == ('col-width-1')

      column = Hpricot(table.xml).search('table:table-column')[2]
      column['table:style-name'].should == ('col-width-2')
    end
  end

end
