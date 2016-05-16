class GitHubPrScraper

  attr_reader :login_user, :pull_requests

  ORGANISATION = ENV['GITHUB_ORGANISATION']

  def initialize
    @login_user = authenticate
    @login_user.auto_paginate = true
    @pull_requests = []
  end

  def fetch_pull_requests
    @pull_requests = login_user.search_issues("is:pr state:open user:#{ORGANISATION}")[:items]
  end

  private

  def authenticate
    @login_user = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end
end
