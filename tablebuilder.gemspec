# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tablebuilder/version"

Gem::Specification.new do |s|
  s.name        = "tablebuilder"
  s.version     = Tablebuilder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Moritz Breit"]
  s.email       = ["mail@mobr.de"]
  s.homepage    = ""
  s.summary     = %q{A simple but flexible table builder for Rails 3}
  s.description = %q{Provides a table builder for your Rails views that creates tables for a collection of objects in a DRY way.}

  s.rubyforge_project = "tablebuilder"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
