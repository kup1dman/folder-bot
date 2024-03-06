class Client
  COMMANDS = {
    group_files: '/group_files',
    done: '/done'
  }

  STATES = {
    normal: 0,
    sending_files: 1
  }

  def start
    Telegram::Bot::Client.run(ENV["TOKEN"]) { |bot| listen_to_messages(bot) }
    @storage = Storage.new
    @state = STATES[:normal]
  end

  private

  def listen_to_messages(bot)
    bot.listen do |message|
      case message.text
      when COMMANDS[:group_files]
        send_message(bot, message, "Отправляйте файлы для группировки. Как закончите, вызывайте команду /done")
        @state = STATES[:sending_files]
      # when COMMANDS[:done]
      #   check_previous_state(bot, message)
      #   @state = STATES[:normal]
      end

      # if message.reply_to_message
      #   handle_replies(bot, message)
      # end

      case @state
      when STATES[:sending_files]
        process_grouping_files(bot, message)
      end
    end
  end

  def process_grouping_files(bot, message)
    if message.document.nil?
      send_message(bot, message, "Это не файл")
    else
      
    end

    if message.text == COMMANDS[:done]
      send_message(bot, message, "Хорошо. Теперь назовите группу", reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
    end

    if message.reply_to_message
      send_message(bot, message, "Группа создана. Файлы сохранены.")
    end
  end

  def handle_replies(bot, message)

  end

  def send_message(bot, message, text, options = {})
    bot.api.send_message(chat_id: message.chat.id, text: text, **options)
  end

  # def hello_message(bot, message)
  #   button = Telegram::Bot::Types::InlineKeyboardButton.new(text: "Отправить файлы", callback_data: '/group_files')
  #   send_message(
  #     bot,
  #     message,
  #     "Привет. Выбери опцию",
  #     reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [button])
  #   )
  # end
end
