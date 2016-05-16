class GitHubPrScraper
  attr_reader :commits, :login_user, :pull_requests

  ORGANISATION = ENV['GITHUB_ORGANISATION']

  def initialize
    @commits = nil
    @login_user = authenticate
    @login_user.auto_paginate = true
    @pull_requests = nil
  end

  def fetch_pull_requests
    @pull_requests = login_user.search_issues("is:pr state:open user:#{ORGANISATION}")[:items]
  end

  def fetch_commits
    @commits = pull_requests.each_with_object({}) do | pr, hash |
      hash[pr[:pull_request][:html_url]] = pr[:body]
    end
  end

  private

  def authenticate
    @login_user = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end
end
