require 'rodf'

require 'rspec_hpricot_matchers'
RspecHpricotMatchers::HaveTag.class_eval do
  def failure_message_when_negated
    negative_failure_message
  end
end
include RspecHpricotMatchers

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.deprecation_stream = File.open('.rspec_deprecation_log','wb')
end
