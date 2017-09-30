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
    if @issue_path.present?
      @issue_path
    else
      raise '@issue_pathが定義されていません'
    end
  end
end
