#!/bin/sh
bundle install && bundle update && bundle exec rake db:reset && ./migrate.sh && ./populate.sh
