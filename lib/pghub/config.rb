module PgHub
  class Config
    attr_accessor :github_organization, :github_access_token

    def initialize
      @github_organization = ''
      @github_access_token = ''
    end
  end
end
