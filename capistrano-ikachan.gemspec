# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/ikachan/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-ikachan"
  spec.version       = Capistrano::Ikachan::VERSION
  spec.authors       = ["linyows"]
  spec.email         = ["linyows@gmail.com"]
  spec.summary       = %q{Integrates Capistrano with Ikachan}
  spec.description   = %q{Integrates Capistrano with Ikachan}
  spec.homepage      = "https://github.com/linyows/capistrano-ikachan"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "string-irc", "~> 0.3.1"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
