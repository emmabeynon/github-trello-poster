# GDS-Github-Trello
[![Build Status](https://travis-ci.org/emmabeynon/gds-github-trello.svg?branch=master)](https://travis-ci.org/emmabeynon/gds-github-trello)

## The Problem
App that queries Github’s API to look at alphagov’s PRs, and when a link to a Trello card is mentioned in the PR, post a message to the team’s Trello board, with the reference of the PR.

## User Stories
As a GOV.UK developer

So that I can make sure that the Trello card I am working on has the correct PR information

I would like a link to relevant PRs to be automatically added to the Trello card.

## Log
**22/04/16**
- Set up Gemfile with Sinatra, RSpec and Capybara gems
- Added Octokit gem for interaction with the API
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

#### Next:
- Grab commits and/or pull request comments for each pull request
