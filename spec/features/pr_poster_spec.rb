require 'github_pr_scraper'

describe 'Pull Request Poster' do
  subject(:scraper) { GitHubPrScraper.new }

  it 'posts a pull request URL to the Trello card referenced in its commit message' do
    scraper.fetch_pull_requests
    scraper.fetch_commits
    scraper.filter_trello_card_ids
    scraper.post_to_trello

    trello_card = Trello::Card.find(scraper.prs_and_trello_card_ids.values[0])

    checklist = trello_card.checklists.first

    expect(checklist.check_items.first['name']).to eq('https://github.com/gov-test-org/project-b/pull/1')

    checklist.delete_checklist_item(checklist.check_items.first['id'])
    checklist.delete
  end
end
