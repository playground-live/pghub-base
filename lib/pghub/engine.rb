require 'pghub/config'

module PgHub
  def self.config
    @config ||= PgHub::Config.new
  end

  def self.configure(&_block)
    yield(config) if block_given?
  end
end
