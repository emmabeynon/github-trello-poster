require 'trello_poster'

describe 'Trello API' do
  subject(:trello_poster_1) { TrelloPoster.new('https://github.com/gov-test-org/project-a/pull/1', 'eciTsr8v') }
  subject(:trello_poster_2) { TrelloPoster.new('https://github.com/gov-test-org/project-b/pull/1', '6wQLN2C7')}

  it 'successfully returns a specified card' do
    expect(trello_poster_1.trello_card.url).to eq('https://trello.com/c/eciTsr8v/19-add-testfile-1-txt-to-project-a')
  end

  it 'checks if a checklist called "Pull Requests" is present' do
    trello_poster_1.access_trello_card
    expect(trello_poster_1.pr_checklist).to eq('5763eec88f68ea12654b44a7')
  end

  it 'creates a checklist called "Pull Requests" if there is not one present' do
    trello_poster_2.access_trello_card
    expect(trello_poster_2.pr_checklist).not_to be nil

    Trello::Checklist.find(trello_poster_2.pr_checklist).delete
  end

  it 'posts a GitHub PR URL to a Trello card checklist called "Pull Requests"' do
    trello_poster_1.access_trello_card
    trello_poster_1.post_github_pr_url

    checklist = Trello::Checklist.find(trello_poster_1.pr_checklist)

    expect(checklist.check_items.first['name']).to eq('https://github.com/gov-test-org/project-a/pull/1')

    checklist.delete_checklist_item(checklist.check_items.first['id'])
  end
end
