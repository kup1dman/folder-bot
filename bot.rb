require 'telegram/bot'
require 'dotenv/load'
require 'pry'

def wait_for_file_send(bot, chat_id)
  bot.listen do |message|
    result = bot.api.get_updates(offset: 0, timeout: 20)
    file_names = result.map { |obj| obj.message.document.file_name.strip }
    bot.api.send_message(chat_id: chat_id, text: "Имена отправляемых файлов:\n#{file_names.join("\n")}")
    return
  end
end

Telegram::Bot::Client.run(ENV["TOKEN"]) do |bot|
  bot.listen do |message|
    case message.text
    when '/file_name'
      bot.api.send_message(chat_id: message.chat.id, text: "Жду файл")
      wait_for_file_send(bot, message.chat.id)
    end
  end
end