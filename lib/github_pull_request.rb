require_relative 'trello_poster'
require 'octokit'

class GitHubPullRequest
  attr_reader :login_user, :merged, :trello_poster

  def initialize(repo:, pull_request_id:, merged:, trello_poster:)
    @login_user = authenticate
    @merged = merged
    @trello_poster = trello_poster
    fetch_pull_request_data(repo, pull_request_id)
  end

  def fetch_pull_request_data(repo, pull_request_id)
    pull_request = login_user.pull_request(repo, pull_request_id)
    unless pull_request.body.empty?
      check_for_trello_card(pull_request.html_url, pull_request.body)
    end
  end

private

  def authenticate
    @authenticate ||= Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def check_for_trello_card(pr_url, pr_body)
    trello_card_url = pr_body.match(%r{https://trello.com/c/\w{8}})
    post_to_trello(pr_url, extract_trello_card_id(trello_card_url)) if trello_card_url
  end

  def extract_trello_card_id(trello_card_url)
    trello_card_url[0].gsub(%r{https://trello.com/c/}, '')
  end

  def post_to_trello(pr_url, trello_card_id)
    trello_poster.post!(pr_url, trello_card_id, merged)
  end
end
