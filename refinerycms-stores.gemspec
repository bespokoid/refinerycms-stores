# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-stores'
  s.version           = '0.0.0'
  s.description       = 'Ruby on Rails Stores engine for Refinery CMS'
  s.date              = '2012-02-13'
  s.summary           = 'Stores engine for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '~> 2.0.0'
  s.add_dependency             'aasm',    '> 3.0'
  s.add_dependency             'haml-rails'
  s.add_dependency             'hpricot'
  s.add_dependency             'ruby_parser'
  s.add_dependency             'stripe'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> 2.0.0'
end
