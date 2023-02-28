# GitHub-Trello-Poster
![Build Status](https://app.travis-ci.com/emmabeynon/github-trello-poster.svg?branch=master)

This app uses GitHub webhooks to be notified when a Pull Request is opened or changed on GitHub.  When it finds a link to a Trello card in the Pull Request, it posts a link to that Pull Request to a checklist on the card it finds.  When a Pull Request is merged or closed, the app checks the Pull Request off the checklist, even in cases where a user may have modified the item in the checklist.

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
