#!/bin/sh
bundle install && bundle exec rake db:test:prepare && bundle exec autotest --rc ../.autotest
