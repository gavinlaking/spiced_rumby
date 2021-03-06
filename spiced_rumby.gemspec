# -*- encoding: utf-8 -*-

# set load path so we can use gemspec with bundler
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spiced_rumby/version'

Gem::Specification.new do |s|
  s.name        = 'spiced_rumby'
  s.version     = SpicedRumby::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['L. Preston Sego III']
  s.email       = 'LPSego3+dev@gmail.com'
  s.homepage    = 'https://github.com/NullVoxPopuli/spiced_rumby'
  s.summary     = "SpicedRumby-#{SpicedRumby::VERSION}"
  s.description = 'A mesh-chat Client in Ruby'

  s.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.executables   = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0'

  s.add_dependency 'meshchat'
  s.add_runtime_dependency 'vedeu'
  s.add_runtime_dependency 'libnotify'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'rubocop'
end
