require 'github_pr_scraper'

describe GitHubPrScraper do
  subject(:scraper) { GitHubPrScraper.new }

  describe 'Default' do
    it 'initializes with login_user set to nil' do
      expect(scraper.login_user).to be_nil
    end

    it 'initializes with repos set to nil' do
      expect(scraper.repos).to be_nil
    end

    it 'initializes with an organisation set to \'alphagov\'' do
      expect(scraper.organisation).to eq 'alphagov'
    end
  end

  describe '#authenticate' do
    it 'authenticates a user' do
      expect(scraper.authenticate).to have_attributes(login: 'emmabeynon')
    end
  end

  describe '#fetch_repos' do
    it 'returns a list of repos on Alphagov' do
      scraper.authenticate
      scraper.fetch_repos
      expect(scraper.repos).not_to be_nil
      #needs a more thorough test i.e. something we would expect to be in repo list
    end
  end
end
