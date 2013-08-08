# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exits/version'

Gem::Specification.new do |spec|
  spec.name          = "exits"
  spec.version       = Exits::VERSION
  spec.authors       = ["Pier-Olivier Thibault"]
  spec.email         = ["pothibo@gmail.com"]
  spec.description   = %q{Exits authorize user to access specific part of your application with a clear syntax}
  spec.summary       = %q{Authorization for your rails' application}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest', "~> 4.2"
end
