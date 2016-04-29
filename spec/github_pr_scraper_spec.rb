require 'github_pr_scraper'

describe GitHubPrScraper do
  subject(:scraper) { GitHubPrScraper.new }

  describe 'Default' do
    it 'initializes with login_user set to an authenticated Github user' do
      expect(scraper.login_user).to have_attributes(login: 'emmabeynon')
    end

    it 'initializes with repos set to nil' do
      expect(scraper.repos).to be_nil
    end

    it 'initializes with an organisation set to \'alphagov\'' do
      expect(scraper.organisation).to eq 'alphagov'
    end

    it 'initializes with pull_requests set to an empty array' do
      expect(scraper.pull_requests).to be_empty
    end
  end

  describe '#fetch_repos' do
    it 'returns a list of repos on Alphagov' do
      scraper.fetch_repos
      expect(scraper.repos.any?{ |hash| hash[:id] == 7052482 }).to be true
    end
  end

  describe '#fetch_pull_requests' do
    it 'returns a list of open pull requests from repos on Alphagov' do
      scraper.fetch_repos
      scraper.fetch_pull_requests
      expect(scraper.pull_requests.any?{ |hash| hash[:url] == "https://api.github.com/repos/alphagov/govspeak/pulls/69" }).to be true
    end
  end
end
