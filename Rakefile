require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList['spec/**/*_test.rb'] + FileList['test/**/*_test.rb']
  t.verbose = true
end

task default: :test
