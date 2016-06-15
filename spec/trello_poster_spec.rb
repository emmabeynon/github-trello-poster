require 'trello_poster'

describe TrelloPoster do
  subject(:trello_poster) { TrelloPoster.new }
  let(:checklist_1) do
    instance_double("Trello::Checklist", {:id=>"575987341d668cc732820859", :name=>"A checklist", :description=>nil, :closed=>nil, :position=>16384, :url=>nil, :check_items=>[{"state"=>"incomplete", "idChecklist"=>"575987341d668cc732820859", "id"=>"57598739c17fbe2dd6d794c0", "name"=>"An item", "nameData"=>nil, "pos"=>17179}],
    :board_id=>"571a072f36769c8d09a11224", :list_id=>nil, :card_id=>"57519cea330ce213a8b53a20", :member_ids=>nil})
  end

  let(:checklist_2) do
    instance_double("Trello::Checklist", {:id=>"57598ceaa5ec5c2a9ac73e8f", :name=>"Pull Requests", :description=>nil, :closed=>nil, :position=>32768, :url=>nil, :check_items=>[{"state"=>"incomplete", "idChecklist"=>"57598ceaa5ec5c2a9ac73e8f", "id"=>"57598d26260429f99a03588d", "name"=>"https://github.com/gov-test-org/project-a/pull/1", "nameData"=>nil, "pos"=>16855}],
    :board_id=>"571a072f36769c8d09a11224", :list_id=>nil, :card_id=>"57519cea330ce213a8b53a20", :member_ids=>nil})
  end

  let(:checklist_3) do
    instance_double("Trello::Checklist", {:id=>"a1b2c3d4e5f6g7h8i9j0klmn", :name=>"Pull Requests", :description=>nil, :closed=>nil, :position=>32768, :url=>nil, :check_items=>[{"state"=>"incomplete", "idChecklist"=>"a1b2c3d4e5f6g7h8i9j0klmn", "id"=>"57598d26260429f99a03588d", "name"=>"https://github.com/gov-test-org/project-a/pull/1", "nameData"=>nil, "pos"=>16855}],
    :board_id=>"571a072f36769c8d09a11224", :list_id=>nil, :card_id=>"57519cea330ce213a8b53a20", :member_ids=>nil})
  end

  let(:card_checklists) { [checklist_1, checklist_2] }

  let(:trello_card) { instance_double("Trello::Card", :checklists => card_checklists, id: '') }

  let(:trello_card_no_checklist) { instance_double("Trello::Card", :checklists => [], id: '5751a0d8b5534a7d47d93d12') }

  describe 'When a Trello card contains a "Pull Requests" checklist' do
    before(:each) do
      allow(Trello::Card).to receive(:find).and_return(trello_card)
      allow(Trello::Checklist).to receive(:find).and_return(checklist_2)
    end

    describe '#access_trello_card' do
      it 'accesses a Trello card using a specific card id' do
        expect(trello_poster.access_trello_card('eciTsr8v')).to eq(trello_card)
      end
    end

    describe '#check_for_pr_checklist' do
      it 'checks for the presence of a PR checklist in a specified Trello card and stores in the pr_checklist array' do
        trello_poster.access_trello_card('eciTsr8v')
        trello_poster.check_for_pr_checklist
        expect(trello_poster.pr_checklist).to include(checklist_2.id)
      end

      it 'does not add a checklist to the pr_checklist array if it is not called "Pull Requests" or "PRs"' do
        trello_poster.access_trello_card('eciTsr8v')
        trello_poster.check_for_pr_checklist
        expect(trello_poster.pr_checklist).not_to include(checklist_1.id)
      end
    end
  end

  describe 'When a Trello card does not contain a "Pull Requests" checklist' do
    before(:each) do
      allow(Trello::Card).to receive(:find).and_return(trello_card_no_checklist)
      allow(Trello::Checklist).to receive(:create).and_return(checklist_3)
    end

    describe '#check_for_pr_checklist' do
      it 'creates a checklist called "Pull Requests" if it does not already exist' do
        trello_poster.access_trello_card('abcd1234')
        expect(trello_poster.pr_checklist).to be nil
        trello_poster.check_for_pr_checklist
        expect(trello_poster.pr_checklist).to eq(checklist_3.id)
      end
    end
  end

end
