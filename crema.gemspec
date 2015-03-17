# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crema/version'

Gem::Specification.new do |spec|
  spec.name          = "crema"
  spec.version       = Crema::VERSION
  spec.authors       = ["Jack Thorne"]
  spec.email         = ["jackkilmerthorne@gmail.com"]
  spec.summary       = %q{A library to write Faraday middleware clients}
  spec.description   = %q{A library to write Faraday middleware clients}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"

  spec.add_runtime_dependency "faraday"
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "dotenv"
end
