module Pghub
  class Config
    attr_accessor :github_organization,
                  :github_access_token,
                  :num_of_assignees,
                  :num_of_reviewers

    def initialize
      @github_organization = ''
      @github_access_token = ''
      @num_of_assignees = {}
      @num_of_reviewers = {}
    end
  end
end
