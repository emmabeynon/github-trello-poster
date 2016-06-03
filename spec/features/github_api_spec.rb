require 'github_pr_scraper'

describe 'Github API' do
  subject(:scraper) { GitHubPrScraper.new }

  it 'returns a list of pull requests on Alphagov' do
    scraper.fetch_pull_requests
    expect(scraper.pull_requests.any? { |pr| pr[:url] == "https://api.github.com/repos/gov-test-org/project-b/issues/1" }).to be true
  end

  it 'returns a list of commits from pull requests on Alphagov' do
    scraper.fetch_pull_requests
    scraper.fetch_commits
    expect(scraper.commits).to include("https://github.com/gov-test-org/project-a/pull/2" => "Trello card is https://trello.com/c/AEjA9me7/20-add-testfile-2-txt-to-project-a")
  end

  it 'returns a list of pull request URLs and corresponding Trello card IDs' do
    scraper.fetch_pull_requests
    scraper.fetch_commits
    scraper.filter_trello_card_ids
    expect(scraper.prs_and_trello_card_ids).to include("https://github.com/gov-test-org/project-b/pull/1"=>"6wQLN2C7")
  end

end
