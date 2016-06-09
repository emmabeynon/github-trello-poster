require 'trello'

class TrelloPoster

  def initialize
    authenticate
  end

  def access_trello_card(trello_card_id)
    Trello::Card.find(trello_card_id)
  end

private

  def authenticate
    Trello.configure do |config|
      config.developer_public_key = ENV['TRELLO_PUBLIC_KEY']
      config.member_token = ENV['TRELLO_MEMBER_TOKEN']
    end
  end

end
