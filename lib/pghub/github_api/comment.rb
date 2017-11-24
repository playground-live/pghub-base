require 'pghub/config'
require 'pghub/github_api/connection'

class GithubAPI
  module Comment
    include Connection

    def post(content)
      connection.post do |req|
        req.url "/repos/#{Pghub.config.github_organization}/#{issue_path}/comments?access_token=#{Pghub.config.github_access_token}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { body: content }.to_json
      end
    end
  end
end
