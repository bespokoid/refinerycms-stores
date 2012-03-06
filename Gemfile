source "http://rubygems.org"

gemspec

gem 'refinerycms', '~> 2.0.0'

# Refinery/rails should pull in the proper versions of these
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'jquery-rails'

group :development, :test do
  gem 'refinerycms-testing', '~> 2.0.0'
  gem 'factory_girl_rails'
  gem 'generator_spec'
  gem 'jeweler'
  gem 'simplecov'

  gem 'rb-inotify', '>= 0.5.1'
  gem 'libnotify',  '~> 0.1.3'

end  # group do
