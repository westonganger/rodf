require_relative 'spec_helper'

describe RODF::DataStyle do
  it "should have sections" do
    output = RODF::DataStyle.create 'year-to-day', :date do |s|
      s.section :year, style: 'long'
      s.section :month, style: 'long'
      s.section :day
    end

    output.should have_tag('number:date-style')
    output.should have_tag('number:year')
    output.should have_tag('number:month')
    output.should have_tag('number:day')

    Hpricot(output).at('number:date-style')['style:name'].should == 'year-to-day'
  end

  it "should allow short section names" do
    output = RODF::DataStyle.create 'year-to-day', :date do |number|
      number.year style: 'long'
      number.month style: 'long'
      number.day
    end

    output.should have_tag('number:year')
    output.should have_tag('number:month')
    output.should have_tag('number:day')
  end

  it "should accept parameterless blocks" do
    output = RODF::DataStyle.create 'year-to-day', :date do
      section :year, style: 'long'
      section :month, style: 'long'
      section :day
    end

    output.should have_tag('number:date-style')
    output.should have_tag('number:year')
  end
end
