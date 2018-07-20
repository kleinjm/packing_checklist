# frozen_string_literal: true

source "https://rubygems.org"

ruby "2.5.0"

gem "jcop", "0.2.3", git: "https://github.com/kleinjm/jcop.git"
gem "wunderlist-api", "1.3.0", git: "https://github.com/kleinjm/wunderlist-api.git"

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
