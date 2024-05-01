require_all 'lib/helpers'
require_relative '../lib/session'
require_relative '../lib/parser'
require_relative '../lib/commands/command'
require_all 'lib/commands'

class Client
  include ApiHelper
  include Session
  include Parser

  def start
    Telegram::Bot::Client.run(ENV['TOKEN']) { |bot| listen_to_messages(bot) }
  end

  private

  def listen_to_messages(bot)
    bot.listen do |message|
      begin
        build_or_update_session(from: message.from, chat: message.chat)
      rescue NoMethodError
        build_or_update_session(from: message.from, chat: message.message.chat)
      end

      case message
      when Telegram::Bot::Types::Message
        handle_data(bot, message, data: message.text) if message.text && message.reply_to_message.nil?
        handle_data(bot, message, data: read(:current_context)) if message.reply_to_message || message.document
      when Telegram::Bot::Types::CallbackQuery
        handle_data(bot, message, data: message.data)
      end
    end
  end

  def handle_data(bot, message, data:)
    command(data)&.new(bot, message)&.call || send_message(bot, message, 'Нет такой команды')
  end
end
