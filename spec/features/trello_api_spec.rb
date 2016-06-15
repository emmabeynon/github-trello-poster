require 'trello_poster'

describe 'Trello API' do
  subject(:trello_poster) { TrelloPoster.new }

  it 'successfully returns a specified card' do
    expect(trello_poster.access_trello_card('eciTsr8v').url).to eq('https://trello.com/c/eciTsr8v/19-add-testfile-1-txt-to-project-a')
  end

  it 'checks if a checklist called "Pull Requests" is present' do
    trello_poster.access_trello_card('eciTsr8v')
    trello_poster.check_for_pr_checklist
    expect(trello_poster.pr_checklist).to eq('57603056d317fa2622f1c6e4')
  end

  it 'creates a checklist called "Pull Requests" if there is not one present' do
    trello_poster.access_trello_card('6wQLN2C7')
    expect(trello_poster.pr_checklist).to be nil

    trello_poster.check_for_pr_checklist
    expect(trello_poster.pr_checklist).not_to be nil

    Trello::Checklist.find(trello_poster.pr_checklist).delete
  end

  it 'posts a GitHub PR URL to a Trello card checklist called "Pull Requests"' do
    trello_poster.access_trello_card('AEjA9me7')
    trello_poster.check_for_pr_checklist
    trello_poster.post_github_pr_url('https://github.com/gov-test-org/project-a/pull/2')

    checklist = Trello::Checklist.find(trello_poster.pr_checklist)

    expect(checklist.check_items.first['name']).to eq('https://github.com/gov-test-org/project-a/pull/2')

    checklist.delete_checklist_item(checklist.check_items.first['id'])
    checklist.delete
  end
end
