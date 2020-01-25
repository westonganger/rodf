require_relative 'spec_helper'

require_relative '../lib/rodf/text'

describe RODF::Text do
  it "should have the expected structure" do
    output = RODF::Text.create
    output.should have_tag('//office:document-content/*')
    output.should have_tag('//office:body/*')
    output.should have_tag('//office:text')
  end

  it "should have paragraphs" do
    output = RODF::Text.create { |doc|
      doc.paragraph "Hello"
      doc.p "World!"
    }
    output.should have_tag('//office:text/*')
    output.should have_tag('//text:p')
    ps = Hpricot(output).search('text:p')
    ps.size.should == 2
    ps.first.innerHTML.should == 'Hello'
    ps.last.innerHTML.should == 'World!'
  end

  it "should allow styles" do
    RODF::Text.create.should_not have_tag('//office:automatic-styles')
    output = RODF::Text.create { |doc|
      doc.style('bold', family: 'text') {|s|
        s.property(:text, 'font-weight' => 'bold') }
      doc.style('italic', family: 'text') {|s|
        s.property(:text, 'font-weight' => 'italic') }
    }
    output.should have_tag('//office:automatic-styles/*', count: 2)
    output.should have_tag('//style:style')
  end

  it "should support page layout as auto-style" do
    output = RODF::Text.create { |doc|
      doc.page_layout 'main-layout'
    }
    output.should have_tag('//office:automatic-styles/*', count: 1)
    output.should have_tag('//style:page-layout')
  end

  it "should support master pages" do
    output = RODF::Text.create do |doc|
      doc.master_page 'standard', layout: 'letter'
    end
    output.should have_tag('//office:master-styles/*', count: 1)
    output.should have_tag('//style:master-page')
  end

  it "should support default styles" do
    output = RODF::Text.create do |doc|
      doc.default_style family: 'paragraph'
    end
    output.should have_tag('//office:styles/*', count: 1)
    output.should have_tag('//style:default-style')
  end
end
