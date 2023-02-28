require "trello_poster"

describe TrelloPoster do
  subject(:trello_poster) { described_class.new }

  let(:trello_client) do
    double Trello::Client,
           find: trello_card_no_checklist,
           create: pull_request_checklist
  end

  let(:another_checklist) do
    instance_double("Trello::Checklist",
                    { id: "1",
                      name: "A checklist",
                      check_items: [
                        { "state" => "incomplete",
                          "id" => "1",
                          "name" => "An item" },
                      ],
                      card_id: "1" })
  end

  let(:pull_request_checklist) do
    instance_double("Trello::Checklist",
                    { id: "2",
                      name: "Pull Requests",
                      check_items: [
                        { "state" => "incomplete",
                          "id" => "1",
                          "name" => "https://github.com/gov-test-org/project-a/pull/1 - Add the UI to frontend" },
                      ],
                      card_id: "1" })
  end

  let(:card_checklists) { [another_checklist, pull_request_checklist] }

  let(:trello_card) do
    instance_double("Trello::Card",
                    checklists: card_checklists,
                    id: "abcd1234")
  end

  let(:trello_card_no_checklist) do
    instance_double("Trello::Card",
                    checklists: [],
                    id: "efgh5678")
  end

  before do
    allow(Trello::Client).to receive(:new).and_return(trello_client)
  end

  context "When a Trello card contains a 'Pull Requests' checklist" do
    before do
      allow(trello_client).to receive(:find).and_return(trello_card)
      allow(pull_request_checklist).to receive(:add_item)
        .with("https://github.com/gov-test-org/project-a/pull/2", false, "bottom")
    end

    context "and trello_card_id is valid" do
      it "finds the Trello card via the Trello API" do
        expect(trello_client).to receive(:find).and_return(trello_card)

        trello_poster.post!(
          "https://github.com/gov-test-org/project-a/pull/2", "abcd1234", false
        )
      end

      it "posts the GitHub PR URL to the 'Pull Requests' checklist" do
        expect(pull_request_checklist).to receive(:add_item)

        trello_poster.post!(
          "https://github.com/gov-test-org/project-a/pull/2", "abcd1234", false
        )
      end

      it "does not post the GitHub PR URL to checklist that is not called 'Pull Requests'" do
        expect(another_checklist).not_to receive(:add_item)

        trello_poster.post!(
          "https://github.com/gov-test-org/project-a/pull/2", "abcd1234", false
        )
      end

      it "does not post the GitHub PR URL more than once" do
        expect(pull_request_checklist).not_to receive(:add_item)

        trello_poster.post!(
          "https://github.com/gov-test-org/project-a/pull/1", "abcd1234", false
        )
      end
    end

    context "and pr_closed is true" do
      before do
        allow(pull_request_checklist).to receive(:update_item_state)
        allow(pull_request_checklist).to receive(:save)
      end

      it "checks off the pull request on the checklist" do
        expect(pull_request_checklist).to receive(:update_item_state)

        trello_poster.post!(
          "https://github.com/gov-test-org/project-a/pull/1", "abcd1234", true
        )
      end
    end

    context "and pr_closed is false" do
      it "does not check off the pull request on the checklist" do
        expect(pull_request_checklist).not_to receive(:update_item_state)

        trello_poster.post!(
          "https://github.com/gov-test-org/project-a/pull/2", "abcd1234", false
        )
      end
    end
  end

  context "When a Trello card does not contain a 'Pull Requests' checklist" do
    before do
      allow(trello_client)
        .to receive(:find).and_return(trello_card_no_checklist)
      allow(pull_request_checklist).to receive(:add_item)
        .with("https://github.com/gov-test-org/project-a/pull/2", false, "bottom")
    end

    it "creates a checklist via the Trello API" do
      expect(trello_client).to receive(:create).and_return(pull_request_checklist)

      trello_poster.post!(
        "https://github.com/gov-test-org/project-a/pull/2", "efgh5678", false
      )
    end
  end
end
