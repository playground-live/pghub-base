require 'support_developer_github/config'

module SupportDeveloperGithub
  def self.config
    @config ||= SupportDeveloperGithub::Config.new
  end

  def self.configure(&block)
    yield(config) if block_given?
  end
end
