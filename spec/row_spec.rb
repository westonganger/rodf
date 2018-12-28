# Copyright (c) 2008 Thiago Arrais
#
# This file is part of rODF.

require_relative 'spec_helper'

require_relative '../lib/rodf/row'

describe RODF::Row do
  it "should allow cells to be added" do
    output = RODF::Row.create
    output.should have_tag('//table:table-row')
    output.should_not have_tag('//table:table-row/*')

    output = RODF::Row.create {|r|
      r.cell
      r.cell
    }
    output.should have_tag('//table:table-row/*', count: 2)
    output.should have_tag('//table:table-cell')
  end

  it "should accept parameterless blocks" do
    output = RODF::Row.create do
      cell
      cell
    end
    output.should have_tag('//table:table-row/*', count: 2)
    output.should have_tag('//table:table-cell')
  end

  it "should has `add_cells` method" do
    output = RODF::Row.create do
      add_cells({ value: 1, type: :string }, 2, 3)
      add_cells [{ value: 4, type: :string }, 5, 6]
    end

    cells = Hpricot(output).search('table:table-cell')

    cells[0]['office:value-type'].should eq 'string'
    cells[0].at('text:p').innerHTML.should eq '1'

    cells[1]['office:value-type'].should eq 'float'
    cells[1]['office:value'].should eq '2'

    cells[3]['office:value-type'].should eq 'string'
    cells[3].at('text:p').innerHTML.should eq '4'

    cells[4]['office:value-type'].should eq 'float'
    cells[4]['office:value'].should eq '5'
  end

  it "should be stylable in the initialization" do
    output = RODF::Row.create 0, style: 'dark' do
      cell
    end
    Hpricot(output).at('table:table-row')['table:style-name'].
      should == 'dark'
  end

  it "should be attr_writer stylable" do
    row = RODF::Row.new
    row.style = 'dark'
    Hpricot(row.xml).at('table:table-row')['table:style-name'].
      should == 'dark'
  end
end
