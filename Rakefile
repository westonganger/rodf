require File.expand_path(File.dirname(__FILE__) + '/lib/rodf/version.rb')
require 'bundler/gem_tasks'

task :test => :spec
task :default => :test

task :spec do
  system("rspec", out: STDOUT)
end

task :console do
  require 'rodf'

  require 'irb'
  binding.irb
end
