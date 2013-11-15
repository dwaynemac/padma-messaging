source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.11'
gem 'rails-api'
gem 'typhoeus', '~> 0.5 '

gem 'foreman'

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
  gem 'newrelic-typhoeus'
  # gem 'unicorn'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'yard', '~> 0.7.4'
  gem 'yard-rest', git: 'git@github.com:dwaynemac/yard-rest-plugin.git'
end

group :test do
  gem 'rake' # for travis-ci
  gem 'coveralls', require: false

  # Pretty printed test output
  gem 'turn', :require => false
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'rb-inotify', :require => false if RUBY_PLATFORM =~ /linux/i
  gem 'libnotify', :require => false if RUBY_PLATFORM =~ /linux/i
end
