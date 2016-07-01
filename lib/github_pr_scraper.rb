require 'trello_poster'

class GitHubPrScraper
  attr_reader :commits, :login_user, :pull_requests, :trello_poster

  ORGANISATION = ENV['GITHUB_ORGANISATION']

  def initialize(trello_poster_klass=TrelloPoster)
    @commits = nil
    @login_user = authenticate
    @login_user.auto_paginate = true
    @pull_requests = nil
    @trello_poster = trello_poster_klass
  end

  def fetch_pull_requests
    @pull_requests = login_user.search_issues("is:pr state:open user:#{ORGANISATION}")[:items]
  end

  def fetch_commits
    @commits = pull_requests.each_with_object({}) do | pr, hash |
      hash[pr[:pull_request][:html_url]] = pr[:body]
    end
  end

  def filter_commits
    commits.each do |k,v|
      unless v.empty?
        trello_card_present = v.match(/https:\/\/trello.com\/c\/\w{8}/)
        post_to_trello(k, extract_trello_card_id(v)) if trello_card_present
      end
    end
  end

private

  def authenticate
    @login_user = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def extract_trello_card_id(v)
    trello_card_present = v.match(/https:\/\/trello.com\/c\/\w{8}/)
    trello_card_present[0].gsub(/https:\/\/trello.com\/c\//, '')
  end

  def post_to_trello(pr_url, trello_card_id)
    trello_poster.new(pr_url, trello_card_id)
  end
end
