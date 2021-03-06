source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.2'
gem 'daemons', '~> 1.2', '>= 1.2.6'
gem 'mysql2', '~> 0.4.5' #used to connect to Filestore Databases
gem 'jbuilder', '~> 2.5'
gem 'rubydora', '~> 2.0'
gem 'http', '~> 3.0'
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'nypl_log_formatter', '~> 0.1.2'
gem 'net-http-digest_auth', '~> 1.4.1'
gem 'rsolr', '~> 1.0.10'
gem 'rsolr-ext', '~> 1.0.3'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :test do
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
end

group :development, :test do
  gem 'puma', '~> 3.7'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'pry', '~> 0.11.3'
end

group :development do
  gem 'rubocop', '~> 0.54.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
