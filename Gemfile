source "https://rubygems.org"
ruby File.read(".ruby-version").strip

gem "dotenv"
gem "octokit", "~> 4.0"
gem "puma"
gem "rubocop-govuk", require: false
gem "ruby-trello", "~> 2.1"
gem "sinatra", "~> 2.0", require: "sinatra/base"

group :test do
  gem "byebug"
  gem "rack-test"
  gem "rspec"
  gem "rspec-sinatra"
  gem "webmock", "~> 3.2"
end
