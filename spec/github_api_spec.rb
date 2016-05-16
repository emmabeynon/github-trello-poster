describe 'Github Trello' do
  subject(:scraper) { GitHubPrScraper.new }

  it 'returns a list of pull requests on Alphagov' do
    scraper.fetch_pull_requests
    expect(scraper.pull_requests).not_to be_empty
  end
end
