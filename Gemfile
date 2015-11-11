source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#gem 'rails', '4.1.1'
gem 'rails', '4.2.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18.2'
# Use SCSS for stylesheets
#gem 'sass-rails' #, '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'execjs'
gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development
gem 'spring-commands-rspec', group: :development

gem 'newrelic_rpm'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
#
# Rails console to work
gem 'rb-readline'

# Detect the language
gem 'whatlanguage'
gem 'prose'

# ActiveModel like for ruby classes
gem 'virtus'

# composite primary keys
gem 'composite_primary_keys', {
  :git => 'git://github.com/composite-primary-keys/composite_primary_keys.git',
  :branch => 'ar_4.2.x'
}

# Printing in console made easy. Simple run or add Rails.logger.ap #YOUR_VAR
gem 'awesome_print'

# Elasticsearch
gem 'elasticsearch-model'
gem 'elasticsearch-rails'


# This is for batching the Content::Translation, batches based on the string primary keys
gem 'batchelor'

# Paging the results
gem 'kaminari'

# nv 'dir'='/base2' rake db:data:dump_dir
gem 'yaml_db', github: 'sharabash/yaml_db'
gem 'sass-rails', '~> 5.0.1'

# This is to run the rake task for importing in parallel
gem 'parallel'
# Will provide a progress bar as the import happens
gem 'ruby-progressbar'

group :development, :test do
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails' # http://betterspecs.org/
  gem 'factory_girl'
  gem 'guard-rspec', require: false
  gem 'rb-fsevent'
  gem 'foreman'
  gem 'passenger' # the webserver
  # Performance testing
  gem 'rails-perftest'
  gem 'ruby-prof'

  gem 'web-console', '~> 2.0'
end

gem 'elasticsearch'

# To allow CORS for the angular project
# https://github.com/cyu/rack-cors
gem 'rack-cors', :require => 'rack/cors'

gem 'httparty'

gem 'annotate'

gem 'actionpack-page_caching'
gem 'actionpack-action_caching'

gem 'redis-rails'
