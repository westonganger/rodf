require_relative 'spec_helper'

require_relative '../lib/rodf/paragraph'
require_relative '../lib/rodf/tab'

describe RODF::Tab do
  it "should be placed inside paragraphs" do
    output = RODF::Paragraph.create {|p|
      p << "Tab"
      p.tab
      p << "test"
    }
    output.should have_tag("//text:p/*", count: 3)
    output.should have_tag("//text:tab")
  end
end
