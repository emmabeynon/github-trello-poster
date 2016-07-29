require 'github_pull_request'

describe 'Pull Request Poster' do
  subject(:scraper) { GitHubPullRequest.new(60356369, 1, false) }
  let(:pull_request) { scraper.login_user.pull_request(60356369, 1) }
  let(:trello_card_id) { pull_request.body.match(/https:\/\/trello.com\/c\/\w{8}/)[0].gsub(/https:\/\/trello.com\/c\//, '') }
  let(:trello_card) { Trello::Card.find(trello_card_id) }

  before(:each) do
    @checklist = trello_card.checklists.first
  end

  after(:each) do
    @checklist.delete_checklist_item(@checklist.check_items.first['id'])
    @checklist.delete
  end

  it 'posts a pull request URL to the Trello card referenced in its commit message' do
    expect(@checklist.check_items.first['name']).to eq(pull_request.html_url)
  end

  it 'does not post a pull request URL to a Trello card if it already exists in the card\'s PR checklist' do
    GitHubPullRequest.new(60356369, 1, false)
    expect(@checklist.check_items.count).to eq(1)
  end

  it 'checks a Pull Request checkbox if it has been merged' do
    GitHubPullRequest.new(60356369, 1, true)
    updated_checklist = trello_card.checklists.first
    expect(updated_checklist.check_items.first['state']).to eq('complete')
  end
end
