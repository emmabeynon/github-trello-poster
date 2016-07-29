require 'github_pull_request'
require 'ostruct'

describe GitHubPullRequest do
  let(:trello_poster) { double(TrelloPoster, new: nil)}
  let(:repo_pull_request) do
    OpenStruct.new({
      html_url: 'https://github.com/gov-test-org/project-b/pull/1',
      body: 'A commit with a Trello URL https://trello.com/c/6wQLN2C7/21-add-randomfile-1-txt-to-project-b'
    })
  end
  let(:octokit) { double Octokit::Client, login: 'emmabeynon', pull_request: repo_pull_request }
  subject(:scraper) { GitHubPullRequest.new(60356369, 1, false, trello_poster) }

  before(:each) do
    allow(Octokit::Client).to receive(:new).and_return(octokit)
  end

  describe 'Default' do
    it 'initializes with login_user set to an authenticated Github user' do
      expect(scraper.login_user).to have_attributes(login: 'emmabeynon')
    end

    it 'initializes with a merge status set' do
      expect(scraper.merge_status).to be false
    end
  end

  describe '#fetch_pull_request_data' do
    it 'retrieves HTML URL and body data for the given URL and passes to the check_for_trello_card method, leading to GitHubPullRequest being instantiated' do
      expect(trello_poster).to receive(:new).with(repo_pull_request[:html_url], '6wQLN2C7', false)
      GitHubPullRequest.new(60356369, 1, false, trello_poster)
    end
  end
end
