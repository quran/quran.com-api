# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.6.3'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails", "~> 6.0.3", ">= 6.0.3.2"

# Use postgresql as the database for Active Record
gem "pg", ">= 0.18", "< 2.0"

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'execjs'
gem 'therubyracer', platforms: :ruby

gem 'active_model_serializers', '~> 0.10.0'

# Http request
gem 'httparty', require: false

gem 'graphql'
gem 'graphql-schema_comparator'
# gem 'graphql-batch'

# Elasticsearch
gem 'excon' # using excon as faraday adapter (net::http breaks)
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# Paging the results
gem 'kaminari'

gem 'oj'
gem 'oj_mimic_json'

# This is to run the rake task for importing in parallel
gem 'parallel'
# Will provide a progress bar as the import happens

gem 'prose'

gem "puma", "~> 4.1"

gem 'rack-cors'
gem 'sitemap_generator'

gem 'virtus'

gem 'tzinfo-data'
gem "bootsnap", ">= 1.4.2", require: false

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
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'benchmark-ips', require: false
  gem 'bullet'
  gem 'derailed_benchmarks'
  gem 'mechanize'
  gem 'meta_request'
  gem 'pre-commit'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'stackprof'
end

group :test, :development do
  #gem 'annotate', '= 2.6.5'
  gem 'guard-rspec', '= 4.7.3'
  gem 'guard-spork'
  gem 'rspec-rails', '= 3.7.2'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'simplecov', require: false
  gem 'database_cleaner-active_record'

  gem "rubocop-rails_config"

  gem 'rubocop-rspec'
  gem 'spork'
  gem 'watchr'
end
