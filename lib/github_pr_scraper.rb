class GitHubPrScraper

  attr_reader :login_user, :organisation, :pull_requests, :repos

  ORGANISATION = ENV['GITHUB_ORGANISATION']

  def initialize(organisation=ORGANISATION)
    @login_user = authenticate
    @login_user.auto_paginate = true
    @organisation = organisation
    @repos = nil
    @pull_requests = []
  end


  def fetch_repos
    @repos = login_user.organization_repositories(organisation, {:type => 'all'})
  end

  def fetch_pull_requests
    repos.each do |repo|
      if !login_user.pull_requests(repo.id).empty?
        @pull_requests << login_user.pull_requests(repo.id)
      end
    end
    @pull_requests.flatten!
  end

  private

  def authenticate
    @login_user = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end
end
