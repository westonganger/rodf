require 'rubygems'
require 'rspec/core/rake_task'
 
RSpec::Core::RakeTask.new
task :default => :spec
task :test => :spec

require 'echoe'
Echoe.new('rodf') do |gem|
  gem.author = ["Weston Ganger", "Thiago Arrais", "Foivos Zakkak"]
  gem.email = "thiago.arrais@gmail.com"
  gem.url = "http://github.com/thiagoarrais/rodf/"
  gem.summary = "ODF generation library for Ruby"

  gem.runtime_dependencies = [
    ["builder", ">= 3.0"],
    ["rubyzip", ">= 1.0"],
    ["activesupport", ">= 3.0", "< 6.0"]]
  gem.development_dependencies = [
    ["rspec", ">= 2.9"],
    ["rspec_hpricot_matchers" , ">= 1.0"],
    ["echoe" , ">= 4.6"]]
end
