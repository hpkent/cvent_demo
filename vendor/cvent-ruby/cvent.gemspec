# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cvent/version'

Gem::Specification.new do |spec|
  spec.name          = "cvent"
  spec.version       = Cvent::VERSION
  spec.authors       = ["Josh Schramm"]
  spec.email         = ["josh.schramm@gmail.com"]
  spec.description   = %q{An interface for integrating with the Cvent API}
  spec.summary       = %q{This gem implements event querying and updating as well as the HTTP Post API for Authentication}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty'
  spec.add_dependency 'savon', '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
