require 'rubygems'
require 'spec/rake/spectask'
 
Spec::Rake::SpecTask.new
task :default => :spec
task :test => :spec

require 'echoe'
Echoe.new('rodf') do |gem|
  gem.author = "Thiago Arrais"
  gem.email = "thiago.arrais@gmail.com"
  gem.url = "http://github.com/thiagoarrais/rodf/tree"
  gem.summary = "ODF generation library for Ruby"

  gem.runtime_dependencies = [
    ["builder", ">= 2.1.2"],
    ["rubyzip", ">= 0.9.1"],
    ["activesupport", "= 2.1.2"]]
  gem.development_dependencies = [
    ["rspec", ">= 1.1.11"],
    ["rspec_hpricot_matchers" , ">= 1.0"],
    ["echoe" , ">= 3.0.2"]]
end
