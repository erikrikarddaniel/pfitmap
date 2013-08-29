source 'https://rubygems.org'

gem 'rails'
gem 'bootstrap-sass', '2.0.3.1'
gem 'faker', '1.0.1'
gem 'will_paginate', '3.0.3'
gem 'bootstrap-will_paginate', '0.0.5'
gem 'bio'
gem 'schema_plus'
gem 'activerecord-import'

# Authentication and Authorization
gem 'omniauth-openid'
gem 'cancan'

# Uploading image files
gem "paperclip", "~> 3.0"

# Talking with biosql at scilifelab.se
gem 'httparty'
gem 'json'

# Delay time-consuming jobs
gem 'delayed_job_active_record', '0.3.2'
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
	gem 'rspec-rails', '2.14.0'
	gem 'annotate', '~> 2.4.1.beta'
end

group :test do
  gem 'capybara-webkit', '~> 1.0.0'	# capybara 2.0 requires some moving, see http://alindeman.github.com/2012/11/11/rspec-rails-and-capybara-2.0-what-you-need-to-know.html
  gem 'database_cleaner' # Added to enable js testing
  gem 'factory_girl_rails', '1.4.0'
  gem 'autotest-standalone', :require => 'autotest'
  gem 'autotest-rails-pure'
  gem 'term-ansicolor'
  gem 'launchy'
  gem 'rspec-html-matchers'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', '0.10.1'

  gem 'uglifier', '>= 1.0.3'
end

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
