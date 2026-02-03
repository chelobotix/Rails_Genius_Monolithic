source "https://rubygems.org"

# AASM for state machine [https://github.com/aasm/aasm]
gem "aasm", "~> 5.5"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Devise for authentication
gem "devise", "~> 5.0"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Mobility for internationalization [https://github.com/discourse/mobility]
gem "mobility"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Pundit for authorization [https://github.com/varvet/pundit]
gem "pundit", "~> 2.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.0"

# Redis for caching and job processing
gem "redis", "~> 5.4"

# Sidekiq for background job processing
gem "sidekiq", "~> 8.1"

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Factory Bot for testing [https://github.com/thoughtbot/factory_bot_rails]
  gem "factory_bot_rails", "~> 6.5"

  # Faker for testing [https://github.com/faker-ruby/faker]
  gem "faker", "~> 3.6"

  # Figaro for environment variables [https://github.com/laserlemon/figaro]
  gem "figaro", "~> 1.3"

  # RSpec for testing [https://rspec.info/]
  gem "rspec-rails", "~> 8.0"

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # VCR for recording and playing back HTTP requests [https://github.com/vcr/vcr]
  gem "vcr", "~> 6.4"

  # WebMock for mocking HTTP requests [https://github.com/bblimke/webmock]
  gem "webmock", "~> 3.26"
end

