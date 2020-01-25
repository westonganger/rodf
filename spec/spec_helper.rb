require 'rspec_hpricot_matchers'
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
