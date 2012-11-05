#!/bin/sh
bundle exec rake db:migrate && bundle exec annotate --position=before && bundle exec rake db:test:prepare && bundle exec rake db:populate
