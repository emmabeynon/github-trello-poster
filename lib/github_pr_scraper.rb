class GitHubPrScraper
  attr_reader :commits, :login_user, :prs_and_trello_card_ids, :pull_requests

  ORGANISATION = ENV['GITHUB_ORGANISATION']

  def initialize
    @commits = nil
    @login_user = authenticate
    @login_user.auto_paginate = true
    @pull_requests = nil
    @prs_and_trello_card_ids = {}
  end

  def fetch_pull_requests
    @pull_requests = login_user.search_issues("is:pr state:open user:#{ORGANISATION}")[:items]
  end

  def fetch_commits
    @commits = pull_requests.each_with_object({}) do | pr, hash |
      hash[pr[:pull_request][:html_url]] = pr[:body]
    end
  end

  def filter_trello_card_ids
    commits.each do |k,v|
      trello_card_present = v.match(/https:\/\/trello.com\/c\/\w{8}/) if v
      if trello_card_present
        @prs_and_trello_card_ids[k] = trello_card_present[0].gsub(/https:\/\/trello.com\/c\//, '')
      end
    end
  end

  private

  def authenticate
    @login_user = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end
end
