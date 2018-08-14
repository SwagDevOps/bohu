# frozen_string_literal: true

# bundle install --path vendor/bundle --clean

source 'https://rubygems.org'

group :development do
  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.58'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
  # repl ---------------------------------
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.11'
  gem 'pry-coolline', '~> 0.2'
  # doc ----------------------------------
  gem 'github-markup', '~> 2.0'
  gem 'redcarpet', '~> 3.4'
  gem 'yard', '~> 0.9'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'sham', '~> 2.0'
end
