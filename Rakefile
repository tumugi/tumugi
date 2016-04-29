require "bundler/gem_tasks"
require "rake/testtask"
require "github_changelog_generator/task"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
end

task :default => :test
