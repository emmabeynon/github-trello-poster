require_relative "trello_poster"
require "octokit"

class GitHubPullRequest
  attr_reader :pull_request_id, :repo_id

  def initialize(closed:, pull_request_id:, repo_id:, trello_poster:)
    @login_user = authenticate
    @closed = closed
    @pull_request_id = pull_request_id
    @repo_id = repo_id
    @trello_poster = trello_poster
  end

  def call
    pull_request = fetch_pull_request_data(repo_id, pull_request_id)
    trello_card_id = check_for_trello_card(pull_request)
    return unless trello_card_id.present?

    post_to_trello(pull_request.html_url, trello_card_id)
  end

private

  attr_reader :login_user, :closed, :trello_poster

  def fetch_pull_request_data(repo_id, pull_request_id)
    login_user.pull_request(repo_id, pull_request_id)
  end

  def authenticate
    @authenticate ||=
      Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"])
  end

  def check_for_trello_card(pull_request)
    return if pull_request.body.empty?

    trello_card_url = pull_request.body.match(%r{https://trello.com/c/\w{8}})
    extract_trello_card_id(trello_card_url) unless trello_card_url.nil?
  end

  def extract_trello_card_id(trello_card_url)
    trello_card_url[0].gsub(%r{https://trello.com/c/}, "")
  end

  def post_to_trello(pr_url, trello_card_id)
    trello_poster.post!(pr_url, trello_card_id, closed)
  end
end
