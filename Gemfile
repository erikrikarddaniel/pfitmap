source 'https://rubygems.org'

gem 'rails'
gem 'bootstrap-sass'
gem 'faker'
gem 'will_paginate'
gem 'bootstrap-will_paginate'
gem 'schema_plus'
gem 'activerecord-import'

###Rails 4.0 gems

#This gem is needed to keep attr_accessible and attr_protected which have been removed from rails 4.0. 
#This gem should be removed and problems fixed
gem 'protected_attributes'
#This gem is needed to keep all dynamic methods except for find_by_... and find_by_...!. Others such as find_all_by have been depreciated.
#This gem should be removed and problems fixed
gem 'activerecord-deprecated_finders'

###

# Authentication and Authorization
gem 'omniauth-openid'
gem 'cancan'

# Uploading image files
gem "paperclip"

# Talking with biosql at scilifelab.se
gem 'httparty'
gem 'json'

# Delay time-consuming jobs
gem 'delayed_job_active_record'
gem 'daemons'

# Debugging memory leak
#gem 'oink'

# Deployment
gem 'capistrano'
gem 'rvm-capistrano'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# profiling
#gem 'newrelic_rpm'

gem 'pg'

gem 'google_visualr'

group :development, :test do
	gem 'rspec-rails'
	gem 'annotate'
end

group :test do
  gem 'capybara-webkit'	# capybara 2.0 requires some moving, see http://alindeman.github.com/2012/11/11/rspec-rails-and-capybara-2.0-what-you-need-to-know.html
  gem 'database_cleaner' # Added to enable js testing
  gem 'factory_girl_rails'
  gem 'autotest-standalone', :require => 'autotest'
  gem 'autotest-rails-pure'
  gem 'term-ansicolor'
  gem 'launchy'
  gem 'rspec-html-matchers'
end
#### These were in the assets group in rails 3.2 that is not needed in rails 4.0 
# Gems used only for assets and not required
# in production environments by default.
####group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer'

  gem 'uglifier'
####end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem 'bio'
