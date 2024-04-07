# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv/load'
require 'pry'
require 'require_all'
require 'redis'

require_relative '../storage'
require_relative '../lib/client'

STORAGE = Storage.new
REDIS = Redis.new
Client.new.start
