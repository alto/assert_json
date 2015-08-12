# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "assert_json/version"

Gem::Specification.new do |s|
  s.name = "assert_json"
  s.version = AssertJson::VERSION
  s.summary = "A gem to test JSON strings."
  s.description = "A gem to test JSON strings."

  s.authors = ["Thorsten Böttger"]
  s.email = %w(boettger@mt7.de)
  s.homepage = 'https://github.com/alto/assert_json'
  s.licenses = ["MIT"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'maxitest'
  s.add_development_dependency 'shoulda-context'
end
