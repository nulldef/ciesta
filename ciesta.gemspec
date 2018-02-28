
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ciesta/version'

Gem::Specification.new do |spec|
  spec.name          = 'ciesta'
  spec.version       = Ciesta::VERSION
  spec.authors       = ['Alexey']
  spec.email         = ['alex.coder1@gmail.com']

  spec.summary       = 'Create form objects easy'
  spec.description   = 'Gem for creating and using form object'
  spec.homepage      = 'https://github.com/nulldef/ciesta'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = ">= 2.0"

  spec.add_dependency 'dry-types', '~> 0.12.1'
  spec.add_dependency 'dry-validation', '~> 0.11.1'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
