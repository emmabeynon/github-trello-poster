require 'trello'

class TrelloPoster
  attr_reader :merge_status, :pr_checklist, :pr_url, :trello_card, :trello_card_id, :client

  def initialize(public_key, token)
    @client = Trello::Client.new( :developer_public_key => public_key, :member_token => token)
  end

  def post!(pr_url, trello_card_id, merge_status)
    @pr_checklist = nil
    @pr_url = pr_url
    @trello_card_id = trello_card_id
    access_trello_card
    post_github_pr_url
    check_off_pull_request if merge_status
  end

  def access_trello_card
    @trello_card = @client.find(:card, trello_card_id)
    check_for_pr_checklist(trello_card)
  end

  def check_for_pr_checklist(trello_card)
    trello_card.checklists.detect do |checklist|
      @pr_checklist = checklist if is_a_pr_checklist?(checklist)
    end
    create_pr_checklist if pr_checklist.nil?
  end

private

  def post_github_pr_url
    unless pr_checklist.check_items.detect { |item| item["name"] == pr_url }
      pr_checklist.add_item(pr_url, checked=false, position='bottom')
    end
  end

  def check_off_pull_request
    check_for_pr_checklist(trello_card)
    pr_checklist.items.each do |item|
      if item.name == pr_url
        pr_checklist.update_item_state(item.id, "complete")
        pr_checklist.save
      end
    end
  end

  def create_pr_checklist
    @pr_checklist = client.create(:checklist, "name" => "Pull Requests", "idCard" => trello_card.id)
  end

  def is_a_pr_checklist?(checklist)
    checklist.name.downcase == "pull requests" || checklist.name.downcase == "prs"
  end
end
