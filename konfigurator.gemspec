# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
require 'konfigurator/version'

Gem::Specification.new do |s|
  s.name             = 'konfigurator'
  s.version          = Konfigurator.version
  s.homepage         = 'http://github.com/nu7hatch/konfigurator'
  s.email            = ['chris@nu7hat.ch']
  s.authors          = ['Chris Kowalik']
  s.summary          = %q{Small and flexible Configuration toolkit inspired i.a. by Sinatra settings.}
  s.description      = %q{Konfigurator is a small and flexible configuration toolkit, which allow you to configure your apps, classes or modules with DSL-style or Sinatra-like settings.}
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths    = %w[lib]
  s.extra_rdoc_files = %w[LICENSE README.rdoc]

  s.add_development_dependency 'contest',     [">= 0.1.2"]
end
