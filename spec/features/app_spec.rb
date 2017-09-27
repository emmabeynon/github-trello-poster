require "spec_helper"
RSpec.describe GithubTrelloPoster do
  include Rack::Test::Methods

  def app
    GithubTrelloPoster.new
  end

  describe "GET '/'" do
    it "returns 200 response" do
      response = get '/'
      expect(response.status).to eq(200)
    end
  end

  describe "POST payload" do
    let(:trello_poster) { TrelloPoster }
    context "valid GitHub pull request payload is received" do
      let(:payload) do
        {
          "pull_request": {
            "merged": true
          },
          "number": 1,
          "repository": {
            "id": 1234
          }
        }
      end

      it "successfully instantiates GitHubPullRequest" do
        expect(GitHubPullRequest).to receive(:new).with(
          merged: true,
          pull_request_id: 1,
          repo_id: 1234,
          trello_poster: trello_poster
        )
        post '/payload', payload.to_json,
          { 'CONTENT_TYPE' => 'application/json'}
      end

      it "returns a 200 status" do
        response = post '/payload', payload.to_json,
          { 'CONTENT_TYPE' => 'application/json'}
        expect(response.status).to eq(200)
        expect(response.body).to be_empty
      end
    end

    context "invalid GitHub pull request payload is received" do
      let(:payload) { { "stuff": "things" } }

      it "does not successfully instantiate GitHubPullRequest" do
        expect(GitHubPullRequest).not_to receive(:new)
        post '/payload', payload.to_json,
          { 'CONTENT_TYPE' => 'application/json'}
      end

      it "returns a 400 error" do
        response = post '/payload', payload.to_json,
          { 'CONTENT_TYPE' => 'application/json'}
        expect(response.status).to eq(400)
        expect(response.body).to eq("Required payload fields missing")
      end
    end
  end
end
