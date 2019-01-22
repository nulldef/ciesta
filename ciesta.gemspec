# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ciesta/version"

Gem::Specification.new do |spec|
  spec.name          = "ciesta"
  spec.version       = Ciesta::VERSION
  spec.authors       = ["Alexey"]
  spec.email         = ["nulldefiner@gmail.com"]

  spec.summary       = "Create form objects easy"
  spec.description   = "Gem for creating and using form object"
  spec.homepage      = "https://github.com/nulldef/ciesta"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  unless spec.respond_to?(:metadata)
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.3"

  spec.add_dependency "dry-types", "~> 0.13"
  spec.add_dependency "dry-validation", "~> 0.12"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "simplecov"
end
