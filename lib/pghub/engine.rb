require 'pghub/config'

module Pghub
  def self.config
    @config ||= Pghub::Config.new
  end

  def self.configure(&_block)
    yield(config) if block_given?
  end
end
