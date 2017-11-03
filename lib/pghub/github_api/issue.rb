require 'pghub/config'
require 'pghub/github_api/connection'

class GithubAPI
  module Issue
    include Connection

    def get_title
      body = issue_response
      body['title']
    end

    private

    def issue_response
      response = connection.get("/repos/#{Pghub.config.github_organization}/#{issue_path}?access_token=#{Pghub.config.github_access_token}")
      JSON.parse(response.body)
    end
  end
end
