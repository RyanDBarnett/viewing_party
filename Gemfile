source 'https://rubygems.org'

git_source(:github) do |repo_name|
   repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.3'

gem 'rails', '5.2.4.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'bootsnap'
gem 'jbuilder', '~> 2.5'
gem 'rubocop', require: false
gem 'bcrypt'
gem 'faraday'

group :development, :test do
  gem 'pry'
  gem 'figaro'
  gem 'travis'
end

group :test do
  gem 'simplecov'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'orderly'
  gem "awesome_print", :require => "ap"
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'webmock'
  gem 'vcr'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-rails'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
