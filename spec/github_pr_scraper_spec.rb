require 'github_pr_scraper'

describe GitHubPrScraper do
  subject(:scraper) { GitHubPrScraper.new }
  let(:octokit) { double Octokit::Client }
  let(:repositories) { [{ id: 7052482 }, { id: 56678576 }] }
  let(:repo_pull_requests) do
    [ { url: 'https://api.github.com/repos/alphagov/govspeak/pulls/69',
        number: 474,
        head: { repo: { id: 7052482 } }
      } ]
  end
  let(:commits) do { commit: { message: 'A commit' } } end

  before(:each) do
    allow(octokit).to receive(:new).and_return(octokit)
    allow(octokit).to receive(:auto_paginate=).and_return true
    allow(scraper.login_user).to receive(:organization_repositories).and_return(repositories)
    allow(scraper.login_user).to receive(:pull_requests).and_return(repo_pull_requests)
    allow(scraper.login_user).to receive(:pull_request_commits).and_return(commits)
  end

  describe 'Default' do
    it 'initializes with login_user set to an authenticated Github user' do
      expect(scraper.login_user).to have_attributes(login: 'emmabeynon')
    end

    it 'initializes with repos set to nil' do
      expect(scraper.repos).to be nil
    end

    it 'initializes with pull_requests set to an empty array' do
      expect(scraper.pull_requests).to be_empty
    end
  end

  describe '#fetch_repos' do
    it 'returns a list of repos on Alphagov' do
      scraper.fetch_repos
      expect(scraper.repos.any?{ |hash| hash[:id] == 7052482 }).to be true
    end
  end

  describe '#fetch_pull_requests' do
    it 'returns a list of open pull requests from repos on Alphagov' do
      scraper.fetch_repos
      scraper.fetch_pull_requests
      expect(scraper.pull_requests.any?{ |hash| hash[:url] == "https://api.github.com/repos/alphagov/govspeak/pulls/69" }).to be true
    end
  end

  describe '#fetch_commits' do
    it 'returns a list of commits from open pull requests on Alphagov' do
      scraper.fetch_repos
      scraper.fetch_pull_requests
      scraper.fetch_commits
      expect(scraper.commits).to include commits
    end
  end

end
