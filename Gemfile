# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web Application
gem 'econfig'
gem 'puma', '~> 3.11'
gem 'roda', '~> 3.8'
gem 'slim', '~> 3.0'

# Validation
gem 'dry-struct', '~> 1.3'
gem 'dry-types', '~> 1.4'

# Networking
gem 'http', '~> 4.0'

# Database
gem 'hirb', '~> 0.7'
gem 'hirb-unicode'
gem 'sequel', '~> 5.0'

group :development, :test do
  gem 'database_cleaner', '~> 1.8'
  gem 'sqlite3', '~> 1.4'
end

group :production do
  gem 'pg'
end
# Testing
gem 'minitest', '~> 5.0'
gem 'minitest-rg', '~> 5.0'
gem 'rerun', '~> 0'
gem 'simplecov', '~> 0'
gem 'vcr', '~> 6.0'
gem 'webmock', '~> 3.0'

# Quality
gem 'flog'
gem 'reek'
gem 'rubocop'

# Utilities
gem 'jieba_rb'
gem 'json'
# gem 'net/http'
gem 'rake'
gem 'string-similarity'
