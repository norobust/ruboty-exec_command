# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruboty/exec_command/version'

Gem::Specification.new do |spec|
  spec.name          = "ruboty-exec_command"
  spec.version       = Ruboty::ExecCommand::VERSION
  spec.authors       = ["Nakai Tooru"]
  spec.email         = ["tr.nakai@gmail.com"]
  spec.summary       = %q{Add command to ruboty as a handler}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ruboty"
  spec.add_runtime_dependency "systemu"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "2.14.1"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "growl"
  spec.add_development_dependency "simplecov"
end
