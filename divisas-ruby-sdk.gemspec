# frozen_string_literal: true

require_relative "lib/divisas_lat/version"

Gem::Specification.new do |spec|
  spec.name = "divisas-ruby-sdk"
  spec.version = DivisasLat::VERSION
  spec.authors = ["Divisas.lat"]
  spec.email = ["support@divisas.lat"]

  spec.summary = "Official Ruby SDK for Divisas.lat"
  spec.description = "High-performance API client for Divisas.lat exchange rates."
  spec.homepage = "https://github.com/divisas-lat/ruby-sdk"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/divisas-lat/ruby-sdk"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ostruct"
end
