# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv/load'
require 'pry'

require './storage'
require 'redis'

Dir['./lib/helpers/*.rb'].sort.each { |file| require file }
require './lib/commands/command'
Dir['./lib/commands/callbacks/*.rb'].sort.each { |file| require file }
Dir['./lib/commands/messages/*.rb'].sort.each { |file| require file }
Dir['./lib/commands/replies/*.rb'].sort.each { |file| require file }
Dir['./lib/*.rb'].sort.each { |file| require file }

STORAGE = Storage.new
REDIS = Redis.new
Client.new.start
