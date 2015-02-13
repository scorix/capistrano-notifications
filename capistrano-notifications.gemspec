# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/notifications/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-notifications'
  spec.version       = Capistrano::Notifications::VERSION
  spec.authors       = ['scorix']
  spec.email         = ['scorix@gmail.com']
  spec.summary       = %q{Capistrano notifications.}
  spec.description   = %q{Send deploy notifications to subscribers.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'capistrano', '~> 3.3.5'

  spec.add_dependency 'faraday'
  spec.add_dependency 'activesupport'
end
