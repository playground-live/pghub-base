class GithubAPI
  module Issue
    include Connection

    def get_title
      body = issue_response
      body['title']
    end

    private

    def issue_response
      response = connection.get("#{issue_path}?access_token=#{ENV['GITHUB_ACCESS_TOKEN']}")
      JSON.parse(response.body)
    end
  end
end
