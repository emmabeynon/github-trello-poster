require 'trello'

class TrelloPoster
  attr_reader :pr_checklist, :pr_url, :trello_card, :trello_card_id

  def initialize(pr_url, trello_card_id)
    authenticate
    @pr_checklist = nil
    @pr_url = pr_url
    @trello_card_id = trello_card_id
    access_trello_card
    post_github_pr_url
  end

  def access_trello_card
    @trello_card = Trello::Card.find(trello_card_id)
    check_for_pr_checklist(trello_card)
  end

  def check_for_pr_checklist(trello_card)
    trello_card.checklists.detect do |checklist|
      @pr_checklist = checklist.id if is_a_pr_checklist?(checklist)
    end
    create_pr_checklist if pr_checklist.nil?
  end

  def post_github_pr_url
    checklist = Trello::Checklist.find(pr_checklist)
    checklist.add_item(pr_url, checked=false, position='bottom')
  end

private

  def authenticate
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_PUBLIC_KEY']
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
  end

  def create_pr_checklist
    @pr_checklist = Trello::Checklist.create(name: "Pull Requests", card_id: trello_card.id).id
  end

  def is_a_pr_checklist?(checklist)
    checklist.name.downcase == "pull requests" || checklist.name.downcase == "prs"
  end

end
