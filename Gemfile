# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.1.0'

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 7.0.8', '>= 7.0.8.1'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'

# For rendering json,
# TODO: turbostreamer replace this with https://github.com/thoughtbot/props_template
# pros_template has simple syntax and slightly faster than turbostreamer
gem 'turbostreamer', '= 1.9'

gem 'graphql', '= 1.11.4'
gem 'graphql-schema_comparator'
#gem 'graphql-playground', github: 'naveed-ahmad/graphql-playground-rails'


#gem 'cld3', '= 3.4.4'
gem 'cld3', '= 3.4.3'

# Elasticsearch
gem 'elastic-transport'
gem 'elasticsearch-model'#, '~> 7.2.0'
gem 'typhoeus'

# Paging the results
gem 'pagy'

gem 'oj'
gem 'oj_mimic_json'

gem 'rails-html-sanitizer', '>= 1.5.0'

# This is to run the rake task for importing in parallel
# Will provide a progress bar as the import happens
gem 'parallel', require: false

# use puma server
gem 'puma', '~> 4.3', '>= 4.3.12'

# enable cors
gem 'rack-cors', '>= 2.0.0'

# compresses Rack responses using Google's Brotli compression algorithm
gem 'rack-brotli'

gem 'tzinfo-data'

# Exception tracking
gem 'sentry-raven', group: [:production]

group :development, :test do
  gem 'pry-rails'
  gem 'apollo-tracing'
  gem 'solargraph', '>= 0.45.0'
end

group :development do
  gem 'byebug', platform: :mri
  gem 'ruby-progressbar'
  gem 'benchmark-ips', require: false
  gem 'bullet'
  gem 'derailed_benchmarks', '>= 2.1.2'

  # run some pre commit hooks
  gem 'pre-commit', require: false
  gem 'rubocop', '>= 1.7.0', require: false

  # https://github.com/tmm1/stackprof
  # sampling call-stack profiler for ruby
  gem 'stackprof'

  # Annotate modes with columns
  gem 'annotate'
end

group :test, :development do
  gem 'rspec-rails', '= 5.0.3'
  gem 'shoulda-matchers', '~> 5.1.0'
  gem 'simplecov', require: false
  gem 'factory_bot_rails', '>= 6.3.0'
  gem 'rubocop-rails_config', '>= 1.9.2'
  gem 'rubocop-rspec', '>= 2.1.0'
  gem 'json-schema-rspec'
end
gem "kredis", "~> 1.3"
