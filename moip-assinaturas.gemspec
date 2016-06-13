# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moip-assinaturas/version'

Gem::Specification.new do |gem|
  gem.name          = "moip-assinaturas"
  gem.version       = Moip::Assinaturas::VERSION
  gem.authors       = ["Warlley"]
  gem.email         = ["warlleyrezende@gmail.com"]
  gem.description   = %q{Ruby Gem para uso do serviço de assinaturas do Moip}
  gem.summary       = %q{Ruby Gem para uso do serviço de assinaturas do Moip}
  gem.homepage      = "https://github.com/ibody/moip-assinaturas"

  gem.add_development_dependency 'rake',          '~> 10.3.2'
  gem.add_development_dependency 'rspec',         '~> 2.13'
  gem.add_development_dependency 'guard-rspec',   '~> 2.5.4'
  gem.add_development_dependency 'growl',         '~> 1.0.3'
  gem.add_development_dependency 'fakeweb',       '~> 1.3.0'
  gem.add_development_dependency 'pry',           '~> 0.9'
  gem.add_development_dependency 'simplecov',     '~> 0.10.0'
  gem.add_dependency             'httparty',      '~> 0.13.0'
  gem.add_dependency             'activesupport', '>= 2.3.2'
  gem.add_dependency             'json',          '>= 1.7'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
