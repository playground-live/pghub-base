require 'pghub/github_api/issue'
require 'pghub/github_api/comment'

class UndefinedIssuePath < StandardError; end

class GithubAPI
  include Issue
  include Comment

  def initialize(issue_path)
    @issue_path = issue_path
  end

  private

  def issue_path
    raise UndefinedIssuePath, '@issue_path is not defined.' if @issue_path.blank?
    @issue_path
  end
end
