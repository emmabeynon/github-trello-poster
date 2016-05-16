require 'github_pr_scraper'

describe 'Github API' do
  subject(:scraper) { GitHubPrScraper.new }

  it 'returns a list of pull requests on Alphagov' do
    scraper.fetch_pull_requests
    expect(scraper.pull_requests).not_to be_empty
  end

  it 'returns a list of commits from pull requests on Alphagov' do
    scraper.fetch_pull_requests
    scraper.fetch_commits
    expect(scraper.commits).not_to be nil
  end

end
