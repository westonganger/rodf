require_relative 'spec_helper'

require_relative '../lib/rodf/table'

describe RODF::Table do
  it "should allow rows to be added" do
    output = RODF::Table.create('Example') {|t| }
    output.should have_tag('//table:table')
    output.should_not have_tag('//table:table/*')

    output = RODF::Table.create('MyTable') {|t| t.row }
    output.should have_tag('//table:table/*', count: 1)
    output.should have_tag('//table:table-row')

    output = RODF::Table.create('MyTable') {|t|
      t.row
      t.row
    }
    output.should have_tag('//table:table/*', count: 2)
    output.should have_tag('//table:table-row')
  end

  it "should provide row numbers" do
    output = RODF::Table.create('Row letter table') {|t|
      t.row {|row| row.cell(row.number)}
    }
    output.should have_tag('table:table-cell')
    Hpricot(output).at('table:table-cell')['office:value-type'].should == 'float'
    Hpricot(output).at('table:table-cell')['office:value'].should == '1'
  end

  it "should allow column style specifications" do
    xml = RODF::Table.create('Styles columns table') do |t|
      t.column style: 'wide'
    end

    xml.should have_tag('table:table-column')
    column = Hpricot(xml).at('table:table-column')
    column['table:style-name'].should == 'wide'
  end

  it "should accept parameterless block" do
    inner = nil
    output = RODF::Table.create('MyTable') {
      row
      row

      inner = self
    }
    expect(inner).to be_an_instance_of RODF::Table
    output.should have_tag('//table:table/*', count: 2)
    output.should have_tag('//table:table-row')
  end

  it "should has `add_rows` method" do
    output = RODF::Table.create('MyTable') {
      add_rows [{ value: 1, type: :string }, 2, 3], [4, 5, 6]
      add_rows [[{ value: 7, type: :string }, 8, 9], [10, 11, 12]]
      add_rows [[13, { value: 14, type: :string }, 15], [16, 17, 18]]
    }
    output.should have_tag('//table:table/*', count: 6)
    output.should have_tag('//table:table-row')

    rows = Hpricot(output).search('table:table-row')

    cells0 = rows[0].search('table:table-cell')

    cells0[0]['office:value-type'].should eq 'string'
    cells0[0].at('text:p').innerHTML.should eq '1'

    cells0[1]['office:value-type'].should eq 'float'
    cells0[1]['office:value'].should eq '2'

    cells1 = rows[1].search('table:table-cell')

    cells1[0]['office:value-type'].should eq 'float'
    cells1[0]['office:value'].should eq '4'

    cells2 = rows[2].search('table:table-cell')

    cells2[0]['office:value-type'].should eq 'string'
    cells2[0].at('text:p').innerHTML.should eq '7'

    cells2[1]['office:value-type'].should eq 'float'
    cells2[1]['office:value'].should eq '8'

    cells3 = rows[3].search('table:table-cell')

    cells3[0]['office:value-type'].should eq 'float'
    cells3[0]['office:value'].should eq '10'

    cells4 = rows[4].search('table:table-cell')

    cells4[0]['office:value-type'].should eq 'float'
    cells4[0]['office:value'].should eq '13'

    cells4[1]['office:value-type'].should eq 'string'
    cells4[1].at('text:p').innerHTML.should eq '14'

    cells5 = rows[5].search('table:table-cell')

    cells5[0]['office:value-type'].should eq 'float'
    cells5[0]['office:value'].should eq '16'
  end

  it "should not instance exec inside block with parameter" do
    inner = nil
    RODF::Table.create('MyTable') do |t|
      inner = self
    end
    expect(inner).to be self
  end

  it "should have children that accept parameterless blocks too" do
    output = RODF::Table.create('MyTable') {
      row {cell}
      row
    }
    output.should have_tag('//table:table/*', count: 2)
    output.should have_tag('//table:table-row')
    output.should have_tag('//table:table-cell')
  end

  it "should have allow row styles" do
    output = RODF::Table.create('MyTable') do
      row style: :bold do
        cell
      end
      row style: :underline do
        cell
      end
    end
    output.should include('table:table-row table:style-name="bold"')
    output.should include('table:table-row table:style-name="underline"')
  end
end
