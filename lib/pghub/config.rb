module Pghub
  class Config
    attr_accessor :github_organization, :github_access_token, :assign_numbers

    def initialize
      @github_organization = ''
      @github_access_token = ''
      @assign_numbers = {}
    end
  end
end
