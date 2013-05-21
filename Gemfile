source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem "active_model_serializers", "~> 0.8.0"

gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.0'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem "ruby-mp3info"
gem "mp4info", git: 'https://github.com/YenTheFirst/ruby-mp4info.git'
gem "squeel"

gem "chronic_duration"

gem 'ejs', '~> 1.0.0'
gem 'eco', '~> 1.0.0'

group :test, :development do
  gem "jasminerice"
  gem "rspec-rails"
end

group :test do
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "guard-rspec"
end

group :production do 
  gem 'therubyracer'
end 

gem 'unicode_utils'
