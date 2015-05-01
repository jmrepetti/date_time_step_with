# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date_time_step_with/version'

Gem::Specification.new do |spec|
  spec.name          = "date_time_step_with"
  spec.version       = DateTimeStepWith::VERSION
  spec.authors       = ["jmrepetti"]
  spec.email         = ["jmrepetti@gmail.com"]
  spec.summary       = %q{Filter dates collection using cron pattern.}
  spec.homepage      = "https://github.com/jmrepetti/date_time_step_with"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
