# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv/load'
require 'pry'
require 'zeitwerk'
require 'redis'
require 'sqlite3'

loader = Zeitwerk::Loader.for_gem
loader.setup

module FolderBot
  ADAPTER = SQLite3::Database.new 'bot.db'
  def self.start
    Client.new.start
  end
end
