require 'trello_poster'

describe 'Trello API' do
  subject(:trello_poster) { TrelloPoster.new }
  
  it 'successfully returns a specified card' do
    expect(trello_poster.access_trello_card('eciTsr8v').url).to eq('https://trello.com/c/eciTsr8v/19-add-testfile-1-txt-to-project-a')
  end
end
