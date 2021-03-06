# MusicRecommendation

Music recommender system using the [cofi_cost gem] (https://github.com/tomwolfe/cofi_cost) collaborative filtering playground.

It's still under active development.

# Build Status (travis-ci.org)

[![Build Status](https://travis-ci.org/tomwolfe/musicrecommendation.png)](https://travis-ci.org/tomwolfe/musicrecommendation)

# Demo (not quite ready for prime time, mostly because the collaborative filtering algorithm needs more love)

You can see a running version of the application at [https://musicrec.herokuapp.com/](https://musicrec.herokuapp.com) (Currently down)

# Hacking

## Installation

Tested on Debian Wheezy.

    sudo apt-get install libgsl0-dev ruby ruby-dev rubygems-integration libxslt-dev libxml2-dev # not tested, xslt/xml needed for nokogiri
    follow these instructions: https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager to install nodejs. You'll have to compile it since it's not in Wheezy's repos.
    git clone git@github.com:tomwolfe/musicrecommendation.git
    cd musicrecommendation
	sudo gem install bundler
    bundle install --without production  # to avoid using the 'thin' webserver in test/development
    bundle exec rake db:migrate

[Get your own keys](http://recaptcha.net/whyrecaptcha.html) for recaptcha.
Setup your recaptcha keys in `config/initializers/recaptcha.rb` use 'config/initializers/recaptcha.rb.example' as a guide.

To use the application run `rails server` in the projects root directory and navigate to http://localhost:3000 in your web browser

I might be missing something, I think that's all I needed to get it running from scratch.

## Deploying to [Heroku](http://www.heroku.com)

You can setup a Heroku account for free [https://devcenter.heroku.com/articles/quickstart](https://devcenter.heroku.com/articles/quickstart)

    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    heroku login
    heroku create
    heroku addons:add memcache  # for caching
    bundle exec rake secret  # to generate SECRET_TOKEN, run again to generate SECRET_KEY_BASE
    # needs a custom buildpack that builds the native extension GSL. These environment variables are persistent and only need to be set once.
    heroku config:add RECAPTCHA_PUBLIC_KEY=YOUR_PUBLIC_KEY RECAPTCHA_PRIVATE_KEY=YOUR_PRIVATE_KEY SECRET_TOKEN=YOUR_SECRET_TOKEN SECRET_KEY_BASE=YOUR_SECRET_KEY_BASE BUILDPACK_URL=https://github.com/tomwolfe/heroku-buildpack-gsl-ruby WEB_CONCURRENCY=3
    git push heroku master
    heroku run rake db:migrate
    heroku restart # to reload the schema and pickup schema changes

## Running Tests

We use RSpec and Cucumber for tests.

Run `bundle exec rake db:test:prepare` to create/setup the test database.

Run `bundle exec rake cucumber spec` to run the tests.

## To-do/completed task list

[Google Spreadsheet](http://goo.gl/3CsWy) contact me at tomwolfe @ gmail dot com to edit.

I'd love to use Pivitol Tracker, but I kind of like just using a spreadsheet and sorting what needs to be done first with the ratio of priority/difficulty.

## License

See COPYING	for legal information. It's an MIT license.

# Thank you

Professor Andrew Ng of Stanford University for his wonderful [Machine learning](https://www.coursera.org/course/ml) class.

Professor Armando Fox and David Patterson of Berkeley for their wonderful [SaaS class](https://www.edx.org/courses/BerkeleyX/CS169.1x/2012_Fall/about).

Professor John Gudenas of Aurora University for getting me interested in artificial intelligence/machine learning.

The many people who made all of the other wonderful tools with which this application is built on (GSL/Ruby/Rails/rspec/cucumber/narray/etc).

[Heroku](http://www.heroku.com) for providing a wonderful platform on which to run this application.

Hopefully I did not forget anyone.
