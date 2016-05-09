class GitHubPrScraper
  attr_reader :commits, :login_user, :pull_requests, :repos

  ORGANISATION = ENV['GITHUB_ORGANISATION']

  def initialize
    @commits = []
    @login_user = authenticate
    @login_user.auto_paginate = true
    @repos = nil
    @pull_requests = []
  end

  def fetch_repos
    @repos = login_user.organization_repositories(ORGANISATION, {:type => 'all'})
  end

  def fetch_pull_requests
    repos.each do |repo|
      repo_pull_requests = login_user.pull_requests(repo[:id])
      @pull_requests << repo_pull_requests if !repo_pull_requests.empty?
    end
    @pull_requests.flatten!
  end

  def fetch_commits
    pull_requests.each do |pull_request|
      @commits << login_user.pull_request_commits(pull_request[:head][:repo][:id], pull_request[:number])
    end
    @commits.flatten!
  end

  private

  def authenticate
    @login_user = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end
end
