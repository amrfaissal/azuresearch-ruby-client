# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'azure_search/version'

Gem::Specification.new do |spec|
  spec.name          = "azure_search"
  spec.version       = AzureSearch::VERSION
  spec.authors       = ["Faissal Elamraoui"]
  spec.email         = ["amr.faissal@gmail.com"]

  spec.summary       = %q{Microsoft Azure Search Client Library for Ruby.}
  spec.description   = %q{Microsoft Azure Search Client Library for Ruby.}
  spec.homepage      = "https://github.com/amrfaissal/azuresearch-ruby-client.git"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'http', '~> 2.2'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
end
