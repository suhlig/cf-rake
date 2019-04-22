# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cloud_foundry/rake/version'

Gem::Specification.new do |spec|
  spec.name          = "cf-rake"
  spec.version       = CloudFoundry::Rake::VERSION
  spec.authors       = ["Steffen Uhlig"]
  spec.email         = ["Steffen.Uhlig@de.ibm.com"]
  spec.summary       = %q{Rake tasks for the Cloud Foundry API}

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'terminal-notifier'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'rb-readline'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'travis'
end
