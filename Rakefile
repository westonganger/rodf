require File.expand_path(File.dirname(__FILE__) + '/lib/rodf/version.rb')
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :test => :spec
task :default => :test

task :console do
  require 'rodf'

  require 'irb'
  binding.irb
end
