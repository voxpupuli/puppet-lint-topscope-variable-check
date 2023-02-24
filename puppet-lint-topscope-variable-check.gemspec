Gem::Specification.new do |spec|
  spec.name        = 'puppet-lint-topscope-variable-check'
  spec.version     = '1.1.0'
  spec.homepage    = 'https://github.com/voxpupuli/puppet-lint-topscope-variable-check'
  spec.license     = 'MIT'
  spec.author      = 'Vox Pupuli'
  spec.email       = 'voxpupuli@groups.io'
  spec.files       = Dir[
    'README.md',
    'LICENSE',
    'lib/**/*',
    'spec/**/*',
  ]
  spec.test_files  = Dir['spec/**/*']
  spec.summary     = 'A puppet-lint plugin to check topscope variables.'
  spec.description = <<-DESC
    A puppet-lint plugin to check that topscope variable names don't start with ::.
  DESC

  spec.add_dependency             'puppet-lint', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-collection_matchers', '~> 1.0'
  spec.add_development_dependency 'rspec-its', '~> 1.0'
  spec.add_development_dependency 'rubocop', '~> 0.58'
  spec.add_development_dependency 'simplecov'
end
