#!/bin/bash
set -e

# Remove old Rails server PID file if it exists
rm -f tmp/pids/server.pid

# Check and install gems first (before using bundle exec)
echo "Checking and installing gems..."
bundle check || bundle install

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USERNAME" -d "postgres" -c '\q' 2>/dev/null; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done
echo "PostgreSQL is up and running!"

# Create database if it doesn't exist
echo "Creating database if it doesn't exist..."
bundle exec rails db:create 2>/dev/null || echo "Database already exists"

# Run migrations
echo "Running migrations..."
bundle exec rails db:migrate

# Execute the final command (rails server or whatever)
exec "$@"
