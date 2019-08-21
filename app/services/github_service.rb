class GithubService
  attr_accessor :access_token

  def initialize(access_hash = nil)
    @access_token = access_hash["access_token"] if access_hash
  end

  def authenticate!(client_id, client_secret, code)
    resp = Faraday.post "https://github.com/login/oauth/access_token", {client_id: client_id, client_secret: client_secret, code: code}, {'Accept' => 'application/json'}
    access_hash = JSON.parse(resp.body)
    @access_token = access_hash["access_token"]
  end

  def get_username
    user_resp = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    user_body = JSON.parse(user_resp.body)
    user_body["login"]
  end

  def get_repos
    resp = Faraday.get "https://api.github.com/user/repos", {}, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
    repos = JSON.parse(resp.body)
    repos = repos.map do |repo|
      GithubRepo.new(repo)
    end
    repos
  end

  def create_repo(name)
    Faraday.post "https://api.github.com/user/repos", {name: name}.to_json, {'Authorization' => "token #{self.access_token}", 'Accept' => 'application/json'}
  end

end
