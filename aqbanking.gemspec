# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aqbanking/version'

Gem::Specification.new do |spec|
  spec.name          = "aqbanking"
  spec.version       = AqBanking::VERSION
  spec.authors       = ["Arthur Leonard Andersen"]
  spec.email         = ["leoc.git@gmail.com"]
  spec.description   = %q{`aqbanking` is a simple wrapper around the AqBanking commandline utilities.}
  spec.summary       = %q{Use aqbanking features from ruby.}
  spec.homepage      = "http://github.com/leoc/ruby-aqbanking"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rubocop"
end
