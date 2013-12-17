#!/bin/sh
bundle install && bundle exec rake db:reset && bundle exec rake db:test:prepare
