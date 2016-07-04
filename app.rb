require 'sinatra/base'
require 'dotenv'
Dotenv.load
require './lib/github_pr_scraper'

class GDSGithubTrello < Sinatra::Base
  get '/' do
    scraper = GitHubPrScraper.new
    scraper.fetch_pull_requests
    scraper.fetch_commits
    scraper.filter_commits
    "Hello GDS-Github-Trello!"
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
