# frozen_string_literal: true

require 'telegram/bot'
require 'dotenv/load'
require 'pry'
require 'zeitwerk'
require 'require_all'
require 'redis'

require_relative '../lib/folder_bot'

FolderBot.start
