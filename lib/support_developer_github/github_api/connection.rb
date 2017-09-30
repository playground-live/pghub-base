require 'support_developer_github/config'
require 'faraday'
require 'faraday_middleware'

class GithubAPI
  module Connection
    def connection
      Faraday.new(url: "https://api.github.com/repos/#{SupportDeveloperGithub.config.github_organization}",
                  ssl: { verify: true }) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter :net_http
        faraday.use FaradayMiddleware::Instrumentation
      end
    end
  end
end
