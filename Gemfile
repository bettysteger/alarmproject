source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'mongoid', '2.3.4'
gem 'bson_ext', '1.5.1'
gem 'json', '1.6.3'
gem 'parallel', '0.5.11'
gem 'jquery-rails'
gem 'typus', git: "git://github.com/fesplugas/typus.git", branch: "master"

# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier',     '>= 1.0.3'
end

group :development do
  gem 'ruby-debug19', :require => 'ruby-debug'
  gem 'sys-proctable'
end

gem 'rspec-rails', '2.6.1', :group => [:development, :test]

group :test do
  gem 'mongoid-rspec', :require => false
  gem 'database_cleaner', '0.6.7'
  gem 'cucumber', '1.1.1'
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end