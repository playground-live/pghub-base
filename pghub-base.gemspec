$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pghub/base/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pghub-base"
  s.version     = Pghub::Base::VERSION
  s.authors     = ["ebkn12, akias, Doppon, seteen, mryoshio, sughimura"]
  s.email       = ["developers@playground.live"]
  s.homepage    = "http://tech-blog.playground.live"
  s.summary     = "Support developer using Github."
  s.description = "This gem offers base function for all gems like pghub-xxx"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "faraday"
end
