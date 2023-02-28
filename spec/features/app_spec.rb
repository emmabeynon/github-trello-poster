require "spec_helper"
RSpec.describe GithubTrelloPoster do
  include Rack::Test::Methods

  def app
    GithubTrelloPoster.new
  end

  describe "GET '/'" do
    it "returns 200 response" do
      response = get "/"
      expect(response.status).to eq(200)
    end
  end

  describe "POST payload" do
    before do
      stub_request(:get, %r{https://api.github.com/repositories/*})
      allow(GitHubPullRequest).to receive(:new).with(github_pull_request_params)
        .and_return(github_pull_request)
      allow(github_pull_request).to receive(:call)
    end

    let(:trello_poster) { TrelloPoster }
    let(:github_pull_request_params) do
      {
        closed: false,
        pull_request_id: 1,
        repo_id: 1234,
        trello_poster: trello_poster,
      }
    end

    let(:github_pull_request) { instance_double("GitHubPullRequest") }
    let(:payload) do
      {
        "action": "open",
        "number": 1,
        "repository": {
          "id": 1234,
        },
      }.to_json
    end

    context "valid GitHub pull request payload is received" do
      it "successfully instantiates GitHubPullRequest" do
        expect(GitHubPullRequest).to receive(:new)
          .with(github_pull_request_params)
        expect(github_pull_request).to receive(:call)

        post "/payload", payload, { "CONTENT_TYPE" => "application/json" }
      end

      it "returns a 200 status" do
        response = post "/payload", payload,
                        { "CONTENT_TYPE" => "application/json" }

        expect(response.status).to eq(200)
        expect(response.body).to be_empty
      end
    end

    context "invalid GitHub pull request payload is received" do
      let(:invalid_payload) { { "stuff": "things" }.to_json }

      it "does not successfully instantiate GitHubPullRequest" do
        expect(GitHubPullRequest).not_to receive(:new)

        post "/payload", invalid_payload,
             { "CONTENT_TYPE" => "application/json" }
      end

      it "returns a 400 error" do
        response = post "/payload", invalid_payload,
                        { "CONTENT_TYPE" => "application/json" }

        expect(response.status).to eq(400)
        expect(response.body).to eq("Required payload fields missing")
      end
    end

    context "PR review is requested" do
      # Github sends two payloads when a PR review is requested, so this ensures
      # only one payload is processed
      let(:review_requested_payload) do
        {
          "action": "review_requested",
          "number": 1,
          "repository": {
            "id": 1234,
          },
        }.to_json
      end

      it "does not successfull instantiate GitHubPullRequest" do
        expect(GitHubPullRequest).to receive(:new).once

        post "/payload", payload, { "CONTENT_TYPE" => "application/json" }

        post "/payload", review_requested_payload,
             { "CONTENT_TYPE" => "application/json" }
      end

      it "returns a 200 status and 'Not processing payload' message" do
        response = post "/payload", review_requested_payload,
                        { "CONTENT_TYPE" => "application/json" }

        expect(response.status).to eq(200)
        expect(response.body).to eq("Not processing payload")
      end
    end
  end
end
