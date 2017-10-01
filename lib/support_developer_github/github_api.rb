require 'support_developer_github/github_api/issue'
require 'support_developer_github/github_api/comment'

class GithubAPI
  include Issue
  include Comment

  def initialize(issue_path)
    @issue_path = issue_path
  end

  private

  def issue_path
    raise '@issue_path is not defined.' if @issue_path.blank?
    @issue_path
  end
end
