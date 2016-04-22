require 'sinatra/base'

class GDSGithubTrello < Sinatra::Base
  get '/' do
    'Hello GDS-Github-Trello!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
