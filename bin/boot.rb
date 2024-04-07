require 'telegram/bot'
require 'dotenv/load'
require 'pry'
require 'require_all'

require_relative '../lib/app'

App.start
