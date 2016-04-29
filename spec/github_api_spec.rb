describe 'Github API' do
  subject(:client) { Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN']) }

  xit 'returns a list of pull requests on Alphagov' do
    client.pull_requests(repo, state: 'open')
  end
end
