require_all 'lib/helpers'
require_relative '../lib/parser'
require_relative '../lib/message_context'
require_relative '../lib/commands/command'
require_all 'lib/commands'

class Client
  include ApiHelper

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
        if message.text && message.reply_to_message.nil?
          handle_message(bot, message)
        elsif message.reply_to_message
          handle_reply(bot, message)
        elsif message.document && App::REDIS.get('current-process') == STATES[:sending_files].to_s
          handle_files(bot, message)
        end
      when Telegram::Bot::Types::CallbackQuery
        handle_callback(bot, message)
      end
    end
  end

  def handle_message(bot, message)
    parser = Parser.new(message, type: :message)
    return send_message(bot, message, 'Нет такой команды') unless parser.command

    parser.command.new(bot, message).call
  end

  def handle_callback(bot, message)
    parser = Parser.new(message, type: :callback)
    return send_message(bot, message, 'Нет такой команды') unless parser.command

    parser.command.new(bot, message).call
  end

  def handle_reply(bot, message)
    parser = Parser.new(message, type: :reply)
    return send_message(bot, message, 'Нет такой команды') unless parser.command

    parser.command.new(bot, message).call
  end

  def handle_files(bot, message)
    if message.document.is_a?(Array)
      message.document.each { |doc| App::STORAGE.write_to_files_table(doc.file_id, App::REDIS.hget('current-group', 'id')) }
    else
      App::STORAGE.write_to_files_table(message.document.file_id, App::REDIS.hget('current-group', 'id'))
    end
  end
end
