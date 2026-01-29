# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=3.3.6
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    postgresql-client \
    yarn \
    wkhtmltopdf \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config set --local force_ruby_platform true && \
    bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Copy and configure entrypoint
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose port 3000
EXPOSE 3000

# Configure entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]

