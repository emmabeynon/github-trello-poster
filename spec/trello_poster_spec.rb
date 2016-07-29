require 'trello_poster'

describe TrelloPoster do
  subject(:trello_poster) { TrelloPoster.new('abcd1234', 'https://github.com/gov-test-org/project-a/pull/2', false) }

  let(:checklist_1) do
    instance_double("Trello::Checklist", {:id=>"575987341d668cc732820859", :name=>"A checklist", :check_items=>[{"state"=>"incomplete", "id"=>"57598739c17fbe2dd6d794c0", "name"=>"An item"}], :card_id=>"57519cea330ce213a8b53a20"})
  end

  let(:checklist_2) do
    instance_double("Trello::Checklist", {:id=>"57598ceaa5ec5c2a9ac73e8f", :name=>"Pull Requests", :check_items=>[{"state"=>"incomplete", "id"=>"57598d26260429f99a03588d", "name"=>"https://github.com/gov-test-org/project-a/pull/1"}],
    :card_id=>"57519cea330ce213a8b53a20"})
  end

  let(:checklist_3) do
    instance_double("Trello::Checklist", {:id=>"a1b2c3d4e5f6g7h8i9j0klmn", :name=>"Pull Requests", :check_items=>[{"state"=>"incomplete", "id"=>"57598d26260429f99a03588d", "name"=>"https://github.com/gov-test-org/project-a/pull/1"}], :card_id=>"57519cea330ce213a8b53a20"})
  end

  let(:card_checklists) { [checklist_1, checklist_2] }

  let(:trello_card) { instance_double("Trello::Card", :checklists => card_checklists, id: '') }

  let(:trello_card_no_checklist) { instance_double("Trello::Card", :checklists => [], id: '5751a0d8b5534a7d47d93d12') }

  describe 'When a Trello card contains a "Pull Requests" checklist' do
    before(:each) do
      allow(Trello::Card).to receive(:find).and_return(trello_card)
      allow(Trello::Checklist).to receive(:find).and_return(checklist_2)
      allow(checklist_2).to receive(:add_item).with("abcd1234", false, "bottom")
    end

    describe '#access_trello_card' do
      it 'accesses a Trello card using a specific card id' do
        expect(trello_poster.trello_card).to eq(trello_card)
      end
    end

    describe '#check_for_pr_checklist' do
      it 'checks for the presence of a PR checklist in a specified Trello card and stores in the pr_checklist variable' do
        expect(trello_poster.pr_checklist).to eq(checklist_2)
      end

      it 'does not store a checklist in the pr_checklist variable if it is not called "Pull Requests" or "PRs"' do
        expect(trello_poster.pr_checklist).not_to eq(checklist_1)
      end
    end
  end

  describe 'When a Trello card does not contain a "Pull Requests" checklist' do
    before(:each) do
      allow(Trello::Card).to receive(:find).and_return(trello_card_no_checklist)
      allow(Trello::Checklist).to receive(:find).and_return(checklist_3)
      allow(Trello::Checklist).to receive(:create).and_return(checklist_3)
      allow(checklist_3).to receive(:add_item).with("abcd1234", false, "bottom")
    end

    describe '#check_for_pr_checklist' do
      it 'creates a checklist called "Pull Requests" if it does not already exist' do
        expect(trello_poster.pr_checklist).to eq(checklist_3)
      end
    end
  end
end
