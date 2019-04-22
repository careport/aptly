lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "aptly/version"

Gem::Specification.new do |spec|
  spec.name = "aptly"
  spec.version = Aptly::VERSION
  spec.author = "CarePort Health"
  spec.summary = <<-DESCRIPTION
    Minimal Ruby library for using the Aptible
    REST API. We can add more functionality as
    we need it.
  DESCRIPTION
  spec.homepage = "https://github.com/careport/aptly"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "oauth2", ">= 1.4.1", "< 2.0"

  spec.add_development_dependency "bundler", ">= 2.0", "< 3.0"
  spec.add_development_dependency "climate_control"
  spec.add_development_dependency "rspec", ">= 3.8", "< 4.0"
  spec.add_development_dependency "webmock", ">= 3.5", "< 4.0"

  spec.required_ruby_version = ">= 2.5"
end
