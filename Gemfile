# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.0.0'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 6.1'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'execjs'
gem 'therubyracer', platforms: :ruby

gem 'active_model_serializers', '~> 0.10.0'

# Http request
gem 'httparty', require: false

gem 'graphql', '1.11.4'
gem 'graphql-schema_comparator'

# Elasticsearch
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'excon' # using excon as faraday adapter (net::http breaks)

# Paging the results
gem 'pagy'

gem 'oj'
gem 'oj_mimic_json'

# This is to run the rake task for importing in parallel
gem 'parallel'
# Will provide a progress bar as the import happens

gem 'prose'

gem 'puma', '~> 4.1'

gem 'rack-cors'

gem 'virtus'

gem 'bootsnap', '>= 1.4.2', require: false
gem 'tzinfo-data'

# Detect the language
gem 'whatlanguage'

gem 'rubocop', require: false

gem 'sentry-raven', group: [:development, :production]

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rails'
  # gem 'zeus'
end

group :development do
  gem 'byebug', platform: :mri
  gem 'ruby-progressbar'
  gem 'benchmark-ips', require: false
  gem 'bullet'
  gem 'derailed_benchmarks'
  gem 'mechanize'
  gem 'meta_request'
  gem 'pre-commit'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'stackprof'
end

group :test, :development do
  gem 'annotate'
  gem 'guard-rspec', '= 4.7.3'
  gem 'guard-spork'
  gem 'rspec-rails', '= 3.7.2'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'simplecov', require: false
  gem 'factory_bot_rails'
  gem 'rubocop-rails_config'
  gem 'rubocop-rspec'
  gem 'spork'
  gem 'watchr'
end
