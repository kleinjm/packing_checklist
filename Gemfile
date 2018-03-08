# frozen_string_literal: true

source "https://rubygems.org"
# TODO: pull token from env var
source "https://<gem_fury_token>@gem.fury.io/kleinjm/"

ruby "2.5.0"

gem "jcop", "0.2.0"
gem "wunderlist-api"

group :development, :test do
  gem "pry"
  gem "pry-nav"
end

group :test do
  gem "climate_control"
  gem "rspec"
  gem "vcr"
  gem "webmock"
end
