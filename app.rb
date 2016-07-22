require 'sinatra/base'
require 'dotenv'
Dotenv.load
require './lib/github_pull_request'
require 'json'

class GDSGithubTrello < Sinatra::Base

  post '/payload' do
    status 204
    body ''
    payload = JSON.parse(request.body.read)
    GitHubPullRequest.new(payload["repository"]["id"],payload["number"])
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

end
