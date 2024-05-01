# frozen_string_literal: true

require 'redis'
require_relative '../storage'
require_relative '../lib/folder_bot/client'

module FolderBot
  STORAGE = Storage.new
  REDIS = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))

  def self.start
    Client.new.start
  end
end
