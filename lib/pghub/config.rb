module Pghub
  class Config
    attr_accessor :github_organization,
                  :github_access_token,
                  :num_of_assignees_per_team,
                  :num_of_reviewers_per_team

    def initialize
      @github_organization = ''
      @github_access_token = ''
      @num_of_assignees_per_team = {}
      @num_of_reviewers_per_team = {}
    end
  end
end
