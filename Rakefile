require 'rake/clean'

desc "Run tests, both RSpec and Cucumber"
task :test => [:spec]

require 'rspec/core/rake_task'
desc "Run RSpec"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--color']
end

require 'rake'

require 'rubygems/tasks'
Gem::Tasks.new
