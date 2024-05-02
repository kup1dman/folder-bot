require_all 'lib/folder_bot/helpers'
require_relative 'session'
require_relative 'parser'
require_relative 'commands/command'
require_all 'lib/folder_bot/commands'

module FolderBot
  class Client
    include Helpers::ApiHelper
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
          handle_data(bot, message, data: message.text, type: :messages) if message.text && message.reply_to_message.nil?
          handle_data(bot, message, data: read(:current_context), type: :replies) if message.reply_to_message || message.document
        when Telegram::Bot::Types::CallbackQuery
          handle_data(bot, message, data: message.data, type: :callbacks)
        end
      end
    end

    def handle_data(bot, message, data:, type:)
      command(data, type)&.new(bot, message)&.call || send_message(bot, message, 'Нет такой команды')
    end
  end
end
