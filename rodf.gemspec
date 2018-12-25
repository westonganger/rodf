require_relative 'lib/rodf/version'

Gem::Specification.new do |s|
  s.name = 'rodf'
  s.description = "ODF generation library for Ruby"
  s.summary = 'This is a library for writing to ODF output from Ruby. It mainly focuses creating ODS spreadsheets.'
  s.version = RODF::VERSION
  s.homepage = 'https://github.com/thiagoarrais/rodf'
  s.authors = ['Weston Ganger', 'Thiago Arrais', 'Foivos Zakkak']
  s.email = ["weston@westonganger.com", "thiago.arrais@gmail.com"]

  s.files = Dir.glob("{lib/**/*}") + %w{ LICENSE.LGPL README.md Rakefile CHANGELOG.md }
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'builder', '>= 3.0'
  s.add_runtime_dependency 'rubyzip', '>= 1.0'
  s.add_runtime_dependency 'activesupport', '>= 3.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec', '>= 2.9'
  s.add_development_dependency 'hpricot', '>= 0.8.6'
  s.add_development_dependency 'rspec_hpricot_matchers', '>= 1.0'
end
