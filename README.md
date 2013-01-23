# MusicRecommendation

Music recommender system using the [cofi_cost gem] (https://github.com/tomwolfe/cofi_cost) collaborative filtering playground.

It's still under active development.

# Build Status (travis-ci.org)

[![Build Status](https://travis-ci.org/tomwolfe/musicrecommendation.png?branch=master)](https://travis-ci.org/tomwolfe/musicrecommendation)

## Hacking

### Development

Tested on Debian Wheezy.
Install libgsl0-dev and [nodejs](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager) (you'll have to compile it since it's not in Wheezy's repos).

I might be missing something, I think that's all I needed to get it running from scratch.

### Production

To push to Heroku you'll need a buildpack that installs GSL. [Using a custom Buildpack](https://devcenter.heroku.com/articles/buildpacks#using-a-custom-buildpack)
Buildpack that includes GSL [gsl-buildpack](https://github.com/tomwolfe/heroku-buildpack-gsl-ruby)_

### To-do/completed task list

[Google Spreadsheet](http://goo.gl/3CsWy) contact me at tomwolfe @ gmail dot com to edit.

I'd love to use Pivitol Tracker, but I kind of like just using a spreadsheet and sorting what needs to be done first with the ratio of priority/difficulty.

## License

See COPYING	for legal information. It's an MIT license.
