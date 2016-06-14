require 'trello'

class TrelloPoster
  attr_reader :pr_checklist, :trello_card

  def initialize
    authenticate
    @pr_checklist = []
  end

  def access_trello_card(trello_card_id)
    @trello_card = Trello::Card.find(trello_card_id)
  end

  def check_for_pr_checklist
    trello_card.checklists.each do |checklist|
      @pr_checklist << checklist.id if is_a_pr_checklist?(checklist)
    end
  end

private

  def authenticate
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_PUBLIC_KEY']
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
  end

  def is_a_pr_checklist?(checklist)
    checklist.name.downcase == "pull requests" || checklist.name.downcase == "prs"
  end
end
