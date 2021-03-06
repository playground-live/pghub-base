require 'pghub/config'
require 'faraday'

class GithubAPI
  module Connection
    def connection
      Faraday.new(url: 'https://api.github.com',
                  ssl: { verify: true }) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.response :raise_error
        faraday.adapter :net_http
      end
    end
  end
end
