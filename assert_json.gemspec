Gem::Specification.new do |s|
  s.name = "assert_json"
  s.summary = "A gem to test JSON strings."
  s.description = "A gem to test JSON strings."
  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]
  
  s.add_dependency 'activesupport'
  s.add_development_dependency 'minitest'
  
  s.version = "0.0.1"
end
