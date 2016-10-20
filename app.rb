require 'sinatra/base'
require 'dotenv'
Dotenv.load
require './lib/github_pull_request'
require 'json'
require 'logger'

class GithubTrelloPoster < Sinatra::Base

  configure :production, :development do
    enable :logging
  end

  get '/' do
    status 200
    erb :index
  end

  post '/payload' do
    status 204
    body ''
    trello_poster = TrelloPoster.new(ENV['TRELLO_PUBLIC_KEY'], ENV['TRELLO_MEMBER_TOKEN'])
    payload = JSON.parse(request.body.read)
    GitHubPullRequest.new(payload["repository"]["id"],payload["number"],payload["pull_request"]["merged"], trello_poster)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

end
