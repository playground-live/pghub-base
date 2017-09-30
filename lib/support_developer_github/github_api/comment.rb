require 'support_developer_github/github_api/connection'

class GithubAPI
  module Comment
    include Connection

    def post(content)
      connection.post do |req|
        req.url "#{issue_path}/comments?access_token=#{ENV['GITHUB_ACCESS_TOKEN']}"
        req.headers['Content-Type'] = 'application/json'
        req.body = { body: content }.to_json
      end
    end
  end
end
