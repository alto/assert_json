#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake/testtask'

desc 'Test the assert_json plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Default: run unit tests.'
task default: :test
