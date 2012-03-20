#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

ENGINE_PATH = File.dirname(__FILE__)
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

if File.exists?(APP_RAKEFILE)
  load 'rails/tasks/engine.rake'
end

#   require "refinerycms-testing"
#
# Refinery::Testing::Railtie.load_tasks
# Refinery::Testing::Railtie.load_dummy_tasks(ENGINE_PATH)

# load File.expand_path('../tasks/testing.rake', __FILE__)
# load File.expand_path('../tasks/rspec.rake', __FILE__)



# encoding: utf-8

require 'rubygems'
require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "refinerycms-stores"
  gem.homepage = "http://github.com/dsaronin@gmail.com/refinerycms-stores"
  gem.license = "MIT"
  gem.summary = %Q{refinerycms shopping cart engine}
  gem.description = %Q{Complete engine for Stripe gateway-based shopping cart to be used with a RefineryCMS project}
  gem.email = "dsaronin@gmail.com"
  gem.authors = ["Daudi Amani"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

# require 'simplecov'
# SimpleCov.start  'rails'

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "refinerycms-stores #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

