require 'trello_poster'

describe TrelloPoster do
  subject(:trello_poster) { TrelloPoster.new }
  let(:trello_card) do
     {:id=>'57519cea330ce213a8b53a20', :short_id=>19, :name=>'Add testfile-1.txt to project-a', :desc=>'', :due=>nil, :closed=>false, :url=>'https://trello.com/c/eciTsr8v/19-add-testfile-1-txt-to-project-a', :short_url=>'https://trello.com/c/eciTsr8v', :board_id=>'571a072f36769c8d09a11224', :member_ids=>[], :list_id=>'571a0762eaef7d7b098bfeee', :pos=>65535, :last_activity_date=>'2016-06-03 15:06:18.234000000 +0000', :card_labels=>[],
    :cover_image_id=>nil, :badges=>{'votes'=>0, 'viewingMemberVoted'=>false, 'subscribed'=>false, 'fogbugz'=>'', 'checkItems'=>0, 'checkItemsChecked'=>0, 'comments'=>0, 'attachments'=>0, 'description'=>false, 'due'=>nil}, :card_members=>nil, :source_card_id=>nil, :source_card_properties=>nil}
  end

  before(:each) do
    allow(Trello::Card).to receive(:find).and_return(trello_card)
  end

  it 'accesses a Trello card using a specific card id' do
    expect(trello_poster.access_trello_card('eciTsr8v')).to eq(trello_card)
  end
end
