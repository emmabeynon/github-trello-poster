describe 'HTTP requests' do
  describe 'POST /payload' do
    it 'returns 204 code and empty body' do
      uri = URI("https://github-trello-poster.cloudapps.digital/payload")
      request = Net::HTTP::Post.new(uri)

      response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
        http.request(request)
      end

      expect(response.code).to eq("204")
      expect(response.body).to be nil
    end
  end
end
