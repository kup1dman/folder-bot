# frozen_string_literal: true

require_relative '../storage'

loader = Zeitwerk::Loader.for_gem
loader.setup

module FolderBot
  STORAGE = Storage.new
  REDIS = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))

  def self.start
    Client.new.start
  end
end
