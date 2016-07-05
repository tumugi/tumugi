# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tumugi/version'

Gem::Specification.new do |spec|
  spec.name          = 'tumugi'
  spec.version       = Tumugi::VERSION
  spec.authors       = ['Kazuyuki Honda']
  spec.email         = ['hakobera@gmail.com']

  spec.summary       = 'Tumugi is a library to build, run and manage complex workflows. Tumugi enables you to define workflows as a ruby code.'
  spec.homepage      = 'https://github.com/tumugi/tumugi'
  spec.license       = 'Apache License Version 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1'

  spec.add_runtime_dependency 'erubis', '~> 2.7.0'
  spec.add_runtime_dependency 'much-timeout', '~> 0.1.1'
  spec.add_runtime_dependency 'parallel', '~> 1.9.0'
  spec.add_runtime_dependency 'ruby-graphviz', '~> 1.2.2'
  spec.add_runtime_dependency 'state_machines'
  spec.add_runtime_dependency 'terminal-table', '~> 1.5.2'
  spec.add_runtime_dependency 'thor', '~> 0.19.1'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'test-unit', '~> 3.1'
  spec.add_development_dependency 'test-unit-rr'
  spec.add_development_dependency 'coveralls'
end
