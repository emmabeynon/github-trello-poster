require 'github_pr_scraper'

describe GitHubPrScraper do
  subject(:scraper) { GitHubPrScraper.new }
  let(:octokit) { double Octokit::Client }
  let(:repos) { [{ id: 7052482 }, { id: 56678576 }] }
  let(:repo_pull_requests) do
    { items: [{url: 'https://api.github.com/repos/alphagov/govspeak/pulls/69'}] }
  end

  before(:each) do
    allow(octokit).to receive(:new).and_return(octokit)
    allow(octokit).to receive(:auto_paginate=).and_return true
    allow(scraper.login_user).to receive(:organization_repositories).and_return(repos)
    allow(scraper.login_user).to receive(:search_issues).and_return(repo_pull_requests)
  end

  describe 'Default' do
    it 'initializes with login_user set to an authenticated Github user' do
      expect(scraper.login_user).to have_attributes(login: 'emmabeynon')
    end

    it 'initializes with pull_requests set to an empty array' do
      expect(scraper.pull_requests).to be_empty
    end
  end

  describe '#fetch_pull_requests' do
    it 'returns a list of open pull requests from repos on Alphagov' do
      scraper.fetch_pull_requests
      expect(scraper.pull_requests.any?{ |hash| hash[:url] == "https://api.github.com/repos/alphagov/govspeak/pulls/69" }).to be true
    end
  end
end
