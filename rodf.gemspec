lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rodf/version'

Gem::Specification.new do |s|
  s.name = 'rodf'
  s.description = "ODF generation library for Ruby"
  s.summary = 'This is a library for writing to ODF output from Ruby. It mainly focuses creating ODS spreadsheets.'
  s.version = RODF::VERSION
  s.homepage = 'https://github.com/thiagoarrais/rodf'
  s.authors = ['Weston Ganger', 'Thiago Arrais']
  s.email = ["weston@westonganger.com", "thiago.arrais@gmail.com"]
  s.license = "MIT"
  
  s.files = Dir.glob("{lib/**/*}") + %w{ LICENSE README.md Rakefile CHANGELOG.md }
  s.require_path = 'lib'

  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'builder', '>= 3.0'
  s.add_runtime_dependency 'rubyzip', '>= 1.0'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec', '>= 3.0'
  s.add_development_dependency 'hpricot', '>= 0.8.6'
  s.add_development_dependency 'rspec_hpricot_matchers', '>= 1.0'
end
