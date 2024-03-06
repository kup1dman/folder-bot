require 'telegram/bot'
require 'dotenv/load'
require 'pry'
require_relative 'client'
require './storage'

Client.new.start