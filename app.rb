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
    payload = JSON.parse(request.body.read)
    if required_payload_fields(payload).present?
      [200, '']
    else
      return [400, 'Required payload fields missing']
    end
    trello_poster = TrelloPoster.new
    GitHubPullRequest.new(
      merged: payload["pull_request"]["merged"],
      pull_request_id: payload["number"],
      repo_id: payload["repository"]["id"],
      trello_poster: trello_poster
    ).call
  end

  def required_payload_fields(payload)
    return false if payload.nil?
    !payload.dig("pull_request", "merged").nil? &&
    payload["number"].present? &&
    payload.dig("repository", "id").present?
  end

  # start the server if ruby file executed directly
  run! if app_file == $0

end
