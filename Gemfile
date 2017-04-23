source 'https://rubygems.org'
ruby '2.3.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.19.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'execjs'
gem 'therubyracer', platforms: :ruby

gem 'oj'
gem 'oj_mimic_json'

gem 'active_model_serializers', '~> 0.10.0'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Detect the language
gem 'whatlanguage'

gem 'puma', '~> 3.0'

# Http request
gem 'httparty', require: false

# Elasticsearch
gem 'elasticsearch'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'parallel'
gem 'passenger'
gem 'prose'

gem 'redis-rails'

gem 'rack-cors'

# Paging the results
gem 'kaminari'

# This is to run the rake task for importing in parallel

# Will provide a progress bar as the import happens
gem 'sentry-raven'

gem 'virtus'

group :development, :test do
  gem 'guard-rspec', require: false
  gem 'parallel_tests'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails' # http://betterspecs.org/
  gem 'zeus'
end

group :development do
  gem 'annotate'
  gem 'bullet'
  gem 'byebug', platform: :mri
  gem 'mechanize'
  gem 'meta_request'
  gem 'pre-commit', require: false
  gem 'rubocop', require: false
  gem 'ruby-progressbar'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
