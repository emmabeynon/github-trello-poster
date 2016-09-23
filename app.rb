require 'sinatra/base'
require 'dotenv'
Dotenv.load
require './lib/github_pull_request'
require 'json'
require 'logger'

class GithubTrelloPoster < Sinatra::Base

  ::Logger.class_eval { alias :write :'<<' }
  access_log = ::File.join(::File.dirname(::File.expand_path(__FILE__)),'.','log','access.log')
  access_logger = ::Logger.new(access_log)
  error_logger = ::File.new(::File.join(::File.dirname(::File.expand_path(__FILE__)),'.','log','error.log'),"a+")
  error_logger.sync = true

  configure do
    use ::Rack::CommonLogger, access_logger
  end

  before {
    env["rack.errors"] =  error_logger
  }

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
