# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/forward_compatible_controller_tests/version'

Gem::Specification.new do |spec|
  spec.name          = "controller-testing-kwargs"
  spec.version       = Rails::ForwardCompatibleControllerTests::VERSION
  spec.authors       = ["Chad Shaffer"]
  spec.email         = ["chad.shaffer@mycase.com"]

  spec.summary       = %q{Back-porting Rails 5 controller & integration tests into Rails 4}
  spec.description   = %q{Makes upgrading to Rails 5 from Rails 4 easier}
  spec.homepage      = "https://github.com/appfolio/controller-testing-kwargs"
  spec.license       = "MIT"

  spec.files         = Dir["{lib}/**/*", "LICENSE.txt", "Rakefile", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "railties", "~> 4.2"

  spec.add_dependency "actionpack", "~> 4.2"
end
