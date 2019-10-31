source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '= 5.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', group: :development
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'dalli'

gem 'jquery-rails'
gem 'bootstrap', '~> 4.3.1'
gem "kramdown"
gem "font-awesome-rails"

# To fix https://github.com/jhund/filterrific/issues/113
gem 'filterrific', github: "maran/filterrific", branch: :master
gem 'jquery-ui-rails'
gem 'activeadmin'
gem 'devise'

gem 'meta-tags'
gem 'kaminari'
gem 'sidekiq'
gem 'simple_form'
gem 'rails-jquery-autocomplete', github: "maran/rails-jquery-autocomplete", branch: :master
gem "sentry-raven"
gem "cookies_eu"
gem 'devise-bootstrap-views', '~> 1.0'
gem "sidekiq-cron", "~> 1.0.4"
gem 'mailgun_rails'
gem "select2-rails"
gem "imgkit"
gem "google-qr"
gem "wkhtmltoimage-binary"
gem "wkhtmltopdf-heroku", github: "maran/wkhtmltopdf-heroku"
gem "google-cloud-vision"
gem "google-cloud-storage", "~> 1.11", require: false
gem 'rack-cors'

#gem 'oj' # Increased json performance and memory usage by using c bindings

# Active class link_to
gem 'active_link_to'
gem 'sitemap_generator'
gem 'fog'
gem "chartkick"
gem 'groupdate'
gem 'acts_as_list'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
#  gem 'derailed_benchmarks'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'apipie-rails'
