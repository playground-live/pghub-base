$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pghub/base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pghub-base"
  s.version     = Pghub::Base::VERSION
  s.authors     = ["ebkn12"]
  s.email       = ["ktennis.mqekr12@gmail.com"]
  s.homepage    = "https://github.com/ebkn12"
  s.summary     = "Support developer using Github."
  s.description = "This gem is base for any gems like pghub-xxx"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"
  s.add_dependency "faraday"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry-rails"
end
