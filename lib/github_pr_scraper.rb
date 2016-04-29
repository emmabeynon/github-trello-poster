class GitHubPrScraper

  attr_reader :login_user, :organisation, :repos

  def initialize(organisation='alphagov')
    @login_user = nil
    @organisation = organisation
    @repos = nil
  end

  def authenticate
    @login_user = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def fetch_repos
    @repos = login_user.repositories(organisation)
  end
end
