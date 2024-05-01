# frozen_string_literal: true

require 'redis'
require_relative '../storage'
require_relative '../lib/client'

module App
  STORAGE = Storage.new
  REDIS = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))

  def self.start
    Client.new.start
  end
end
