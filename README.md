# MusicRecommendation

Music recommender system using the [cofi_cost gem] (https://github.com/tomwolfe/cofi_cost) collaborative filtering playground.

It's still under active development.

# Build Status (travis-ci.org)

[![Build Status](https://travis-ci.org/tomwolfe/musicrecommendation.png)](https://travis-ci.org/tomwolfe/musicrecommendation)

# Hacking

## Installation

Tested on Debian Wheezy.

    sudo apt-get install libgsl0-dev ruby ruby-dev rubygems-integration # not tested
    follow [these instructions](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) to install nodejs. You'll have to compile it since it's not in Wheezy's repos.
    git clone git@github.com:tomwolfe/musicrecommendation.git
    cd musicrecommendation
    bundle install --without production    (to avoid using the 'thin' webserver in test/development)
    rake db:migrate

[Get your own keys](http://recaptcha.net/whyrecaptcha.html) for recaptcha.
Setup your recaptcha keys in `config/initializers/recaptcha.rb`

To use the application run `rails server` in the projects root directory and navigate to http://localhost:3000 in your web browser

I might be missing something, I think that's all I needed to get it running from scratch.

## Deploying to [Heroku](http://www.heroku.com)

You can setup a Heroku account for free [https://devcenter.heroku.com/articles/quickstart](https://devcenter.heroku.com/articles/quickstart)

    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    heroku login
    #bundle install   #might need this to update gemfile.lock to include thin?
    heroku create
    heroku addons:add memcache  # for caching
    rake secret  # to generate SECRET_TOKEN
    heroku config:add RECAPTCHA_PUBLIC_KEY=YOUR_PUBLIC_KEY RECAPTCHA_PRIVATE_KEY=YOUR_PRIVATE_KEY SECRET_TOKEN=YOUR_SECRET_TOKEN BUILDPACK_URL=https://github.com/tomwolfe/heroku-buildpack-gsl-ruby # needs a custom buildpack that builds the native extension GSL
    git push heroku master
    heroku run rake db:migrate

## Running Tests

We use RSpec and Cucumber for tests.

Run `rake db:test:prepare` to create/setup the test database.

Run `bundle exec rake cucumber spec` to run the tests.

## Caching

Currently caching is turned on for the development environment (cache stored in `/tmp/cache`). Set `config.action_controller.perform_caching = false` in `config/environments/development.rb` to turn it off.

## To-do/completed task list

[Google Spreadsheet](http://goo.gl/3CsWy) contact me at tomwolfe @ gmail dot com to edit.

I'd love to use Pivitol Tracker, but I kind of like just using a spreadsheet and sorting what needs to be done first with the ratio of priority/difficulty.

## License

See COPYING	for legal information. It's an MIT license.
