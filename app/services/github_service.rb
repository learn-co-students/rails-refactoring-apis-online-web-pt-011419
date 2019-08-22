class GithubService

    # here
    def initialize(access_hash = nil)
        @access_token = access_hash['access_token'] if access_hash
    end

    def authenticate!(client_id, client_secret, code)
        resp = Faraday.post("https://github.com/login/oauth/access_token") do |req|
            req.params['client_id'] = client_id
            req.params['client_secret'] = client_secret
            req.params['code'] = code
        end
    end
end