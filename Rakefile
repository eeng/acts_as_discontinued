require "bundler/gem_tasks"
require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'lib/acts_as_discontinued'
  t.test_files = FileList['test/acts_as_discontinued/*_test.rb']
  t.verbose = true
end
task :default => :test