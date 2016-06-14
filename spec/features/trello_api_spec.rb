require 'trello_poster'

describe 'Trello API' do
  subject(:trello_poster) { TrelloPoster.new }

  it 'successfully returns a specified card' do
    expect(trello_poster.access_trello_card('eciTsr8v').url).to eq('https://trello.com/c/eciTsr8v/19-add-testfile-1-txt-to-project-a')
  end

  it 'checks if a checklist called "Pull Requests" is present' do
    trello_poster.access_trello_card('eciTsr8v')
    trello_poster.check_for_pr_checklist
    expect(trello_poster.pr_checklist).to include("57598ceaa5ec5c2a9ac73e8f")
  end
end
