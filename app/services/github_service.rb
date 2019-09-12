class GithubService
    attr_reader :access_token

    def initialize(access_hash = nil)
        @access_token = access_hash["access_token"] if access_hash
    end

    def authenticate!(client_id, client_secret, code)
        resp = Faraday.post "https://github.com/login/oauth/access_token", {client_id: ENV["GITHUB_CLIENT"], client_secret: ENV["GITHUB_SECRET"], code: code}, {'Accept' => 'application/json'}
        access_hash = JSON.parse(resp.body)
        @access_token = access_hash["access_token"]
    end

end