# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zoom/version"

Gem::Specification.new do |gem|
  gem.add_dependency "httparty", ">= 0.13"
  gem.add_dependency "json", ">= 1.8"
  gem.add_dependency "jwt"

  gem.add_development_dependency "pry-byebug"
  gem.add_development_dependency "standard", ">= 1.25.0"
  gem.add_development_dependency "rubocop-rspec", ">= 2.19.0"
  gem.add_development_dependency "rspec", ">= 3.8"
  gem.add_development_dependency "rspec_junit_formatter", ">= 0.4.1"
  gem.add_development_dependency "simplecov", ">= 0.22.0"
  gem.add_development_dependency "simplecov-lcov", ">= 0.8.0"
  gem.add_development_dependency "webmock", ">= 3.4"

  gem.authors = ["Kyle Boe"]
  gem.email = ["kyle@boe.codes"]
  gem.description = "A Ruby API wrapper for zoom.us API"
  gem.summary = "zoom.us API wrapper"
  gem.homepage = "https://github.com/kyleboe/zoom_rb"
  gem.licenses = ["MIT"]

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.name = "zoom_rb"
  gem.require_paths = ["lib"]
  gem.version = Zoom::VERSION
end
