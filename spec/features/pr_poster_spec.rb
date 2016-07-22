require 'github_pull_request'

describe 'Pull Request Poster' do
  subject(:scraper) { GitHubPullRequest.new(60356369, 1) }

  before(:each) do
    @pull_request = scraper.login_user.pull_request(60356369, 1)
    @pr_url = @pull_request.html_url
    @trello_card_id = @pull_request.body.match(/https:\/\/trello.com\/c\/\w{8}/)[0].gsub(/https:\/\/trello.com\/c\//, '')
    @trello_card = Trello::Card.find(@trello_card_id)
    @checklist = @trello_card.checklists.first
  end

  it 'posts a pull request URL to the Trello card referenced in its commit message' do
    expect(@checklist.check_items.first['name']).to eq(@pr_url)

    @checklist.delete_checklist_item(@checklist.check_items.first['id'])
    @checklist.delete
  end

  it 'does not post a pull request URL to a Trello card if it already exists in the card\'s PR checklist' do
    GitHubPullRequest.new(60356369, 1)

    expect(@checklist.check_items.count).to eq(1)

    @checklist.delete_checklist_item(@checklist.check_items.first['id'])
  end
end
