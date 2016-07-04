require 'github_pr_scraper'

describe GitHubPrScraper do
  subject(:scraper) { GitHubPrScraper.new }

  let(:octokit) { double Octokit::Client }
  let(:trello_poster) { double TrelloPoster }
  let(:commits) do
    { 'https://github.com/alphagov/transition/pull/511' =>
      'A commit with a Trello URL https://trello.com/c/Xf9vMxZ9/5-grab-all-commit-messages-from-open-pull-requests' }
  end
  let(:repo_pull_requests) do
    { items: [
      { pull_request: {
          html_url: 'https://github.com/alphagov/transition/pull/511' },
        body: 'A commit with a Trello URL https://trello.com/c/Xf9vMxZ9/5-grab-all-commit-messages-from-open-pull-requests'
      }
    ] }
  end
  let(:prs_and_trello_card_ids) do
    { 'https://github.com/alphagov/transition/pull/511' => 'Xf9vMxZ9'}
  end

  before(:each) do
    allow(octokit).to receive(:new).and_return(octokit)
    allow(octokit).to receive(:auto_paginate=).and_return true
    allow(scraper.login_user).to receive(:search_issues).and_return(repo_pull_requests)
  end

  describe 'Default' do
    it 'initializes with login_user set to an authenticated Github user' do
      expect(scraper.login_user).to have_attributes(login: 'emmabeynon')
    end

    it 'initializes with pull_requests set to nil' do
      expect(scraper.pull_requests).to be_nil
    end

    it 'initializes with commits set to nil' do
      expect(scraper.commits).to be_nil
    end
  end

  describe '#fetch_pull_requests' do
    it 'returns a list of open pull requests from repos on Alphagov' do
      scraper.fetch_pull_requests
      expect(scraper.pull_requests).to eq repo_pull_requests[:items]
    end
  end

  describe '#fetch_commits' do
    it 'returns a list of commits from open pull requests on Alphagov' do
      scraper.fetch_pull_requests
      scraper.fetch_commits
      expect(scraper.commits).to eq commits
    end
  end

  describe '#filter_commits' do
    it 'filters commits for those containing Trello card URLs and initializes a new trello poster instance' do
      expect(TrelloPoster).to receive(:new).with(commits.keys.first, 'Xf9vMxZ9').and_return(trello_poster)
      scraper.fetch_pull_requests
      scraper.fetch_commits
      scraper.filter_commits
    end
  end
end
