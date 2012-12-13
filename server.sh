#!/bin/sh
bundle exec rake jobs:work &
bundle exec rails server
