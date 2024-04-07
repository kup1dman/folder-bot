# frozen_string_literal: true

require 'redis'
require_relative '../storage'
require_relative '../lib/client'
module App
  STORAGE = Storage.new
  REDIS = Redis.new

  def self.start
    Client.new.start
  end
end
