source "https://rubygems.org"

ruby "1.9.3"

group :development, :test do
	gem "sqlite3", "~> 1.3"
	gem "rspec-rails"
	gem "debugger", "~> 1.6"
end

group :production do
	gem "pg", "~> 0.17"
	gem "thin"
	gem "dalli", "~> 2.6"
	gem "memcachier", "~> 0.0.2"
end

group :test do
	gem "cucumber-rails", "~> 1.4"
	gem "cucumber", "~> 1.3"	# temp, problems with 1.2.2
	gem "selenium-webdriver", "~> 2.37" # problems with 2.31.0
	gem "database_cleaner", "~> 1.2"
	gem "capybara", "~> 2.1"
	gem "rspec-expectations", "~> 2.14"
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
	gem "coffee-rails"
	gem "uglifier", "~> 2.3"
end

gem "jquery-rails", "~> 3.0"

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use ActiveModel has_secure_password
gem "bcrypt-ruby", "~> 3.0.0" # 3.0 needed, else dependency problem

gem "haml", "~> 4.0"

gem "haml-rails"

gem "cofi_cost", "~> 0.0"

gem "narray", "~> 0.6.0"

gem "gsl", github: "romanbsd/rb-gsl"

gem "recaptcha", "~> 0.3", require: "recaptcha/rails"

gem "will_paginate", "~> 3.0"

gem "itunes-search-api", "~> 0.1"

gem "rbrainz", "~> 0.5"
