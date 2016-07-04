require 'github_pr_scraper'

describe 'Pull Request Poster' do
  subject(:scraper) { GitHubPrScraper.new }

  it 'posts a pull request URL to the Trello card referenced in its commit message' do
    scraper.fetch_pull_requests
    scraper.fetch_commits
    scraper.filter_commits

    pr_url = scraper.commits.keys.first
    trello_card_id = scraper.commits[pr_url].match(/https:\/\/trello.com\/c\/\w{8}/)[0].gsub(/https:\/\/trello.com\/c\//, '')

    trello_card = Trello::Card.find(trello_card_id)

    checklist = trello_card.checklists.first
    expect(checklist.check_items.first['name']).to eq(pr_url)

    checklist.delete_checklist_item(checklist.check_items.first['id'])
    checklist.delete
  end

  it 'does not post a pull request URL to a Trello card if it already exists in the card\'s PR checklist' do
    2.times do
      scraper.fetch_pull_requests
      scraper.fetch_commits
      scraper.filter_commits
    end

    pr_url = scraper.commits.keys.first
    trello_card_id = scraper.commits[pr_url].match(/https:\/\/trello.com\/c\/\w{8}/)[0].gsub(/https:\/\/trello.com\/c\//, '')

    trello_card = Trello::Card.find(trello_card_id)

    checklist = trello_card.checklists.first
    expect(checklist.check_items.count).to eq(1)

    checklist.delete_checklist_item(checklist.check_items.first['id'])
  end
end
