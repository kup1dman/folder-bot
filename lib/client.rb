require_all 'lib/helpers'
require_relative '../lib/session'
require_relative '../lib/parser'
require_relative '../lib/commands/command'
require_all 'lib/commands'

class Client
  include ApiHelper
  include Session
  include Parser

  STATES = {
    normal: 0,
    sending_files: 1
  }.freeze

  def start
    Telegram::Bot::Client.run(ENV['TOKEN']) { |bot| listen_to_messages(bot) }
  end

  private

  def listen_to_messages(bot)
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::Message
        handle_data(bot, message, data: message.text, type: :message) if message.text && message.reply_to_message.nil?
        handle_data(bot, message, data: read(:current_context)) if message.reply_to_message
        # handle_data(bot, message, data: message.document)
        # handle_files(bot, message) if message.document && App::REDIS.get('current-process') == STATES[:sending_files].to_s
      when Telegram::Bot::Types::CallbackQuery
        handle_data(bot, message, data: message.data)
      end
    end
  end

  def handle_data(bot, message, data:, type: nil)
    command(data, type)&.new(bot, message)&.call || send_message(bot, message, 'Нет такой команды')
  end

  def handle_files(bot, message)
    if message.document.is_a?(Array)
      message.document.each { |doc| App::STORAGE.write_to_files_table(doc.file_id, App::REDIS.hget('current-group', 'id')) }
    else
      App::STORAGE.write_to_files_table(message.document.file_id, App::REDIS.hget('current-group', 'id'))
    end
  end
end
