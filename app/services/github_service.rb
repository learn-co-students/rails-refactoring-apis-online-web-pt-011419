class GithubService
    attr_reader :access_token

    def initialize(access_hash = nil)
        # binding.pry
        @access_token = access_hash["access_token"] if access_hash
    end
    
    def authenticate!(client_id, client_secret, code)
        resp = Faraday.post "https://github.com/login/oauth/access_token", 
        {client_id: client_id, client_secret: client_secret, code: code}, 
        {'Accept' => 'application/json'}
        
        access_hash = JSON.parse(resp.body)
        @access_token = access_hash["access_token"]
      end

      def get_username
        resp = Faraday.get ("https://api.github.com/user") do |r|
            r.headers = {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
        end
        parsed = JSON.parse(resp.body)
        parsed["login"]
        # binding.pry
        
      end

      def get_repos
        resp = Faraday.get ("https://api.github.com/user/repos") do |r|
            r.headers = {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
        end
        # binding.pry
        parsed = JSON.parse(resp.body)
        parse_array = []
        parsed.each do |p|
            parse_array << GithubRepo.new(p)
        end
        # binding.pry
        parse_array
      end

      def create_repo(repo_name)
        # binding.pry
        resp = Faraday.post "https://api.github.com/user/repos", {name: repo_name}.to_json, {'Authorization' => "token #{@access_token}", 'Accept' => 'application/json'}
        
      end

    end