# GitHub-Trello-Poster
[![Build Status](https://travis-ci.org/emmabeynon/github-trello-poster.svg?branch=master)](https://travis-ci.org/emmabeynon/github-trello-poster)

This app uses GitHub webhooks to be notified when a Pull Request is opened or changed on GitHub.  When it finds a link to a Trello card in the Pull Request, it posts a link to that Pull Request to a checklist on the card it finds.  When a Pull Request is merged, the app checks the Pull Request off the checklist.

## User Stories
```
As a GOV.UK developer

So that I can make sure that the Trello card I am working on has the correct PR information

I would like a link to relevant PRs to be automatically added to the Trello card.


As a GOV.UK developer

So that I can make sure that Pull Request information on the Trello card I am working on is up to date

I would like the link to a Pull Request to be checked off after I have merged it.
```

## Technical Documentation
This app is built using Ruby and Sinatra.  It makes use of GitHub webhooks to receive pull request information, and the Trello API to post pull request information to Trello cards.

#### Setting up the app
1. Clone the repo down to your local machine.
2. Run `bundle install`.
3. Get your [GitHub access token](https://help.github.com/articles/creating-an-access-token-for-command-line-use/) and assign to the `GITHUB_ACCESS_TOKEN` environment variable.
4. Get your [Trello developer API key](https://trello.com/app-key) and assign to the `TRELLO_PUBLIC_KEY` environment variable. You may also find this key using [ruby-trello's](https://github.com/jeremytregunna/ruby-trello) helpful methods.
5. Get your [Trello user token](https://developers.trello.com/authorize) and assign to the `TRELLO_MEMBER_TOKEN` environment variable. You may also find this token using [ruby-trello's](https://github.com/jeremytregunna/ruby-trello) helpful methods.
6. To set up a Webhook:

    a. Navigate to your chosen organisation or repository's settings on GitHub. Select 'Webhooks' and click 'Add webhook'  

    b. Paste your payload URL (i.e. 'https://[insert-your-site-here]/payload') in the Payload URL box.

    c. Select content type as application/json.

    d. Select 'Let me select individual events' and check the 'Pull requests' box.

    e. Leave the Active checkbox checked, and save.
7. Deploy to your preferred platform, or to run locally, run `ruby app.rb`.  If running locally, I would recommend using [ngrok](https://ngrok.com/) to create a secure tunnel to your localhost.

#### Running the test suite
Run `bundle exec rspec`.
Note the feature tests require real-world set up of Trello cards and GitHub repos, and you will need to amend the tests accordingly.

## Log
**22/04/16**
- Set up Gemfile with Sinatra, RSpec and Capybara gems
- Added Octokit gem for interaction with the GitHub API
- Set up a Trello board

**29/04/16**
- Added Dotenv gem to maintain secret keys
- Created tests to authenticate API, fetch alphagov repos and fetch pull requests
- Created GitHubPrScraper class to manage interaction with GithHub API

**05/05/16**
- Fixed Octokit pagination so that all repos are retrieved
- Set up Travis CI

**09/05/16**
- Github API is mocked using let statements
- Now able to fetch a list of commits from each open pull request

**16/05/16**
- Fetch pull requests method changed to use Github search to grab all open pull requests on Alphagov, which has sped up the interaction with the API
- Fetch commits method has been altered to work with the new fetch pull requests method
- Fetch repos has been removed as it's now redundant

**01/06/16**
- Method created to filter commits for links to Trello cards
- Currently using two data structures - one to store all PR URLs and commit body, and one to store PR URLs filtered by those containing a Trello card URL in the commit body.  Unsure at this point whether the combine the two, but will see how the code develops.

**03/06/16**
- Added ruby-trello gem to interact with the Trello API
- Trello is authenticated using basic authentication - struggling to make it work using OAuth currently.
- Set up a dummy Github organisation for testing
- Changed feature tests to work with dummy Github organisation

**10/06/16**
- Trello cards can now be accessed via the API using a unique card ID
- Method created to check for the presence of a Pull Requests checklist on a given card
- If a Pull Requests checklist is present, its id is stored in an array

**14/06/16**
- A Pull requests checklist is created if one is not already present.

**15/06/16**
- Added functionality to post a GitHub PR URL to a Pull Requests checklist.

**17/06/16**
- TrelloPoster is now injected as a dependency in the GitHubPrScraper class
- GitHubPrScraper iterates through prs_and_trello_card_ids and creates an instance of the TrelloPoster class to post the PR URL to the Trello card

**04/07/16**
- TrelloPoster and GitHubPrScraper classes refactored to reduce dependency on each other
- Added functionality to check if a given PR URL is already in the Pull Requests checklist.  If it is, then it will not be posted again.
- Implemented Sinatra

**15/07/16**
- Implemented a webhook that listens for changes to pull requests e.g. being opened, being closed, being edited, and creates an instance of the GitHubPrScraper class after receiving a payload from Github
- This has required a reworking of the GitHubPrScraper class to deal with single pull requests, as opposed to the previous implementation that scraped all open pull requests from an organisation.  Consequently, the name of this class has been changed to GitHubPullRequest.
- GitHub API tests have been removed as this is covered by the pr_poster feature tests

**22/07/16**
- Removed Trello API specs as this is covered by the unit tests and pr_poster feature tests
- Not sure how to test posting to Trello (#post_github_pr_url), as the API is mocked

**29/07/16**
- Pull request item checkbox on the Trello card 'Pull Requests' checklist is checked once a pull request has been merged.

**05/08/16**
- I've changed the Trello authentication so that a Trello client is created to handle all interactions with the Trello API.  This has cleaned up Trello authentication, and means we can call ruby-trello methods on a client variable now.
- TrelloPoster is now instantiated in app.rb and passed into the GitHubPullRequest instance. This has made it easier to stub in tests.
- A post! method has been extracted out of TrelloPoster's initalize method to handle all posting related methods.  This is called on the TrelloPoster instance from within the GitHubPullRequest instance.  Initialize now only handles authentication.
- Minor refactoring has been carried out on the GitHubPullRequest class to make regex conditions clearer, and renamed merge_status to merged.
- After discussing setting up OAuth for Trello with @alext, we decided that the current basic authentication is sufficient, so I will not be proceeding with setting up OAuth.

**19/08/16**
- I'm looking at modifying this app to be able to post Pivotal Tracker as an alternative to Trello.  This can be found [here](https://github.com/emmabeynon/github-pivotal-poster)

**05/09/16**
- The app has been deployed to the PaaS!

**23/09/16**
- Sinatra logging as been added.
- Added test for HTTP request.
