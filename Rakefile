# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
require 'konfigurator/version'
require 'rake/rdoctask'
require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Konfigurator #{Konfigurator.version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => :test

desc "Build current version as a rubygem"
task :build do
  `gem build konfigurator.gemspec`
  `mv konfigurator-*.gem pkg/`
end

desc "Relase current version to rubygems.org"
task :release => :build do
  `git tag -am "Version bump to #{Konfigurator.version}" v#{Konfigurator.version}`
  `git push origin master`
  `git push origin master --tags`
  `gem push pkg/konfigurator-#{Konfigurator.version}.gem`
end

