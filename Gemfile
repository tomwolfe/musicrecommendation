source "https://rubygems.org"

ruby "1.9.3"

group :development, :test do
	gem "sqlite3", "~> 1.3"
	gem "rspec-rails", "~> 2.13"
	gem "debugger", "~> 1.3"
end

group :production do
	gem "pg", "~> 0.14"
	gem "thin", "~> 1.5"
	gem "dalli", "~> 2.6"
end

group :test do
	gem "cucumber-rails", "~> 1.3"
	gem "cucumber", "1.2.1"	# temp, problems with 1.2.2
	gem "selenium-webdriver", "2.30.0" # problems with 2.31.0
	gem "database_cleaner", "~> 0.9"
	gem "capybara", "~> 2.0"
	gem "rspec-expectations", "~> 2.13"
	gem "factory_girl_rails", "~> 4.2"
	#gem "ZenTest"
end

gem "rails", "~> 3.2"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
	gem "sass-rails", "~> 3.2"
	gem "coffee-rails", "~> 3.2"
	gem "uglifier", "~> 1.3"
end

gem "jquery-rails", "~> 2.2"

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use ActiveModel has_secure_password
gem "bcrypt-ruby", "~> 3.0"

gem "haml", "~> 4.0"

gem "haml-rails", "~> 0.4"

gem "cofi_cost", "~> 0.0"

gem "narray", "~> 0.6.0"

gem "gsl", git: "git://github.com/romanbsd/rb-gsl.git", ref: "fd601dfcd0b05319fa8f66f1e73cd711d5ba9ed9"

gem "rbrainz", "~> 0.5"

gem "recaptcha", "~> 0.3", require: "recaptcha/rails"

gem "will_paginate", "~> 3.0"

gem "itunes-search-api", "~> 0.1"
