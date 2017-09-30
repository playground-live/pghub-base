class GithubAPI
  module Connection
    def connection
      Faraday.new(url: "https://api.github.com/repos/#{ENV['GITHUB_ORGANIZATION']}",
                  ssl: { verify: true }) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter :net_http
        faraday.use FaradayMiddleware::Instrumentation
      end
    end
  end
end
