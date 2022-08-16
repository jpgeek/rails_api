# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'bcrypt', '~> 3.1'
gem 'bootsnap', '~> 1.13', require: false
gem 'jbuilder', '~> 2.11'
gem 'jwt', '~> 2.4'
gem 'mysql2', '~> 0.5'
gem 'puma', '~> 5.0'
gem 'pundit', '~> 2.2'
gem 'rails', '~> 7.0.3', '>= 7.0.3.1'
# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making
# cross-origin AJAX possible.
# DISABLED.  Enable only when we know which domains to allow, and if AJAX is even
# required.
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'pundit-matchers'
  gem 'rspec-rails', '= 6.0.0.rc1'
  gem 'shoulda-matchers', '~> 5.0'
end

group :development do
  gem 'rubocop'
  gem 'rubocop-rails_config'
end
