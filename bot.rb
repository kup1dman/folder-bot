require 'telegram/bot'
require 'dotenv/load'
require 'pry'
require_relative 'client'
require './storage'
require './state'

Client.new.start