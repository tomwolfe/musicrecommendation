source "https://rubygems.org"

ruby "1.9.3"

group :development, :test do
	gem "sqlite3", "~> 1.3"
	gem "rspec-rails"
	gem "debugger"
end

group :production do
	gem "pg", "~> 0.17"
	gem "unicorn"
	gem "dalli", "~> 2.6"
	gem "memcachier", "~> 0.0.2"
	gem "rails_12factor"
end

group :test do
	gem "cucumber-rails", "~> 1.4", :require => false
	gem "cucumber", "~> 1.3"
	gem "selenium-webdriver", "~> 2.37"
	gem "database_cleaner", "~> 1.2"
	gem "capybara", "~> 2.1"
	gem "rspec-expectations", "~> 2.14"
	gem "factory_girl_rails", "~> 4.2"
	#gem "ZenTest"
end

gem "rails", "~> 4.0"

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# pre-rails 4 => :assets group
gem "sass-rails", "~> 4.0"
gem "coffee-rails", "~> 4.0"
gem "uglifier", "~> 2.3"

gem "jquery-rails", "~> 3.0"

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use ActiveModel has_secure_password
gem "bcrypt-ruby"

gem "haml", "~> 4.0"

gem "haml-rails", "~> 0.5.0"

gem "cofi_cost", "~> 0.0"

gem "narray", "~> 0.6.0"

gem "gsl", github: "romanbsd/rb-gsl"

gem "recaptcha", "~> 0.3", require: "recaptcha/rails"

gem "will_paginate", "~> 3.0"

gem "itunes-search-api", "~> 0.1"

gem "musicbrainz", github: "tomwolfe/musicbrainz", branch: "fix_tracksearch"

gem "rack-timeout"
