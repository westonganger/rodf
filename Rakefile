require 'spec/rake/spectask'
 
task :default => :spec
Spec::Rake::SpecTask.new

require 'echoe'
Echoe.new('rodf') do |gem|
  gem.author = "Thiago Arrais"
  gem.email = "thiago.arrais@gmail.com"
  gem.url = "http://github.com/thiagoarrais/rodf/tree"
  gem.summary = "ODF generation library for Ruby"

  gem.runtime_dependencies = [
    "builder >= 2.1.2",
    "rubyzip >= 0.9.1",
    "activesupport >= 2.0.0"]
  gem.development_dependencies = ["rspec_hpricot_matchers >= 1.0"]
end
