require_relative 'spec_helper'

describe RODF::Skeleton do
  it "should have the expected structure" do
    output = RODF::Skeleton.new.styles
    output.should have_tag('//office:document-styles/*')
    output.should have_tag('//office:font-face-decls')
    output.should have_tag('//office:styles', count: 1)
    output.should have_tag('//style:style', count: 1)
    output.should have_tag('//number:number-style', count: 2)
    output.should have_tag('//number:date-style', count: 1)
  end
end
