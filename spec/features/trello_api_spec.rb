require 'trello_poster'

describe 'Trello API' do
  subject(:trello_poster) { TrelloPoster.new }

  it 'successfully returns a specified card' do
    expect(trello_poster.access_trello_card('eciTsr8v').url).to eq('https://trello.com/c/eciTsr8v/19-add-testfile-1-txt-to-project-a')
  end

  it 'checks if a checklist called "Pull Requests" is present' do
    trello_poster.access_trello_card('eciTsr8v')
    trello_poster.check_for_pr_checklist
    expect(trello_poster.pr_checklist).to include('57603056d317fa2622f1c6e4')
    expect(trello_poster.pr_checklist.count == 1).to be true
  end

  it 'creates a checklist called "Pull Requests" if there is not one present' do
    trello_poster.access_trello_card('6wQLN2C7')
    expect(trello_poster.pr_checklist).to be_empty
    trello_poster.check_for_pr_checklist
    expect(trello_poster.pr_checklist).not_to be_empty
    expect(trello_poster.pr_checklist.count == 1).to be true
    Trello::Checklist.find(trello_poster.pr_checklist.first).delete
  end
end
