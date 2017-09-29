require 'trello'

class TrelloPoster
  def initialize
    @client = Trello::Client.new(
      :developer_public_key => ENV['TRELLO_PUBLIC_KEY'],
      :member_token => ENV['TRELLO_MEMBER_TOKEN']
    )
  end

  def post!(pr_url, trello_card_id, pr_closed)
    trello_card = access_trello_card(trello_card_id)
    pr_checklist = check_for_pr_checklist(trello_card)
    post_github_pr_url(pr_url, pr_checklist)
    check_off_pull_request(trello_card, pr_url) if pr_closed
  end

private

  attr_reader :client

  def access_trello_card(trello_card_id)
    client.find(:card, trello_card_id)
  end

  def check_for_pr_checklist(trello_card)
    checklist = trello_card.checklists.detect do |checklist|
      return checklist if is_a_pr_checklist?(checklist)
    end
    create_pr_checklist(trello_card) if checklist.nil?
  end

  def post_github_pr_url(pr_url, pr_checklist)
    unless checklist_has_pr_url?(pr_checklist, pr_url)
      pr_checklist.add_item(pr_url, checked=false, position='bottom')
    end
  end

  def check_off_pull_request(trello_card, pr_url)
    checklist = check_for_pr_checklist(trello_card)
    checklist.check_items.each do |item|
      if item["name"] == pr_url
        checklist.update_item_state(item["id"], "complete")
        checklist.save
      end
    end
  end

  def create_pr_checklist(trello_card)
    client.create(:checklist,
      "name" => "Pull Requests",
      "idCard" => trello_card.id
    )
  end

  def is_a_pr_checklist?(checklist)
    checklist.name.downcase == "pull requests" ||
      checklist.name.downcase == "prs"
  end

  def checklist_has_pr_url?(checklist, pr_url)
    checklist.check_items.detect { |item| item["name"] == pr_url }
  end
end
