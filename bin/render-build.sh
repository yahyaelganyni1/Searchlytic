#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# Skip seed for database deployment failures
if [ "${SKIP_SEED:-false}" != "true" ]; then
  bundle exec rails db:seed
fi