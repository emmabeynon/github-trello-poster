require 'github_pull_request'
require 'ostruct'

describe GitHubPullRequest do
  let(:trello_poster) { double(TrelloPoster) }

  let(:repo_pull_request) do
    OpenStruct.new({
      html_url: 'https://github.com/gov-test-org/project-b/pull/1',
      body: 'A commit with a Trello URL https://trello.com/c/6wQLN2C7/21-add-randomfile-1-txt-to-project-b'
    })
  end

  let(:octokit) do
    double Octokit::Client,
      login: 'username',
      pull_request: repo_pull_request
  end

  let(:github_pull_request_params) do
    {
      repo_id: 60356369,
      pull_request_id: 1,
      merged: false,
      trello_poster: trello_poster
    }
  end

  before(:each) do
    allow(Octokit::Client).to receive(:new).and_return(octokit)
    allow(trello_poster).to receive(:post!)
  end

  describe 'Default' do
    let(:github_pr) { GitHubPullRequest.new(github_pull_request_params) }
    it 'initializes with a pull_request_id' do
      expect(github_pr.pull_request_id).to eq(1)
    end

    it 'initializes with a repo_id' do
      expect(github_pr.repo_id).to eq(60356369)
    end
  end

  describe '#call' do
    context "when a pull request body contains a valid Trello URL" do
      it "instantiates GitHubPullRequest" do
        expect(trello_poster).to receive(:post!)
          .with(repo_pull_request[:html_url], '6wQLN2C7', false)
        GitHubPullRequest.new(github_pull_request_params).call
      end
    end

    context "when a pull request body does not contain a valid Trello URL" do
      before do
        repo_pull_request.body = "A commit without a Trello URL"
      end

      it "does not instantiate GitHubPullRequest" do
        expect(trello_poster).not_to receive(:post!)
        GitHubPullRequest.new(github_pull_request_params).call
      end
    end
  end
end
