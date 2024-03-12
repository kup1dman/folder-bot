class Client
  COMMANDS = {
    group_files: '/group_files',
    done: '/done',
    create_group: '/create_group',
    list_of_groups: '/list_of_groups'
  }

  STATES = {
    normal: 0,
    sending_files: 1
  }

  def initialize
    @storage = Storage.new
    @state = STATES[:normal]
    @group_id = nil
  end

  def start
    Telegram::Bot::Client.run(ENV["TOKEN"]) { |bot| listen_to_messages(bot) }
  end

  private

  def listen_to_messages(bot)
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::CallbackQuery
        case message.data
        when COMMANDS[:create_group]
          send_message(bot, message, "Назовите группу", reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
          @state = STATES[:sending_files]
        when COMMANDS[:list_of_groups]
          names =  @storage.get_group_names.to_a.flatten
          names.map do |name|
            Telegram::Bot::Types::InlineKeyboardButton.new(text: name, callback_data: "/pick_group_#{names.index(name)}")
          end
          send_message(
            bot, message, "Выберите группу",
            reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [kb])
          )
        end
      when Telegram::Bot::Types::Message
        case message.text
        when COMMANDS[:group_files]
          kb = [
            Telegram::Bot::Types::InlineKeyboardButton.new(text: "Создать группу", callback_data: COMMANDS[:create_group]),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: "Список групп", callback_data: COMMANDS[:list_of_groups])
          ]
          send_message(
            bot, message, "Выберите желаемое",
            reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [kb])
          )
        else
          process_grouping_files(bot, message) if STATES[:sending_files]
        end
        end
    end
  end

  def process_grouping_files(bot, message)
    if message.document
      if message.document.is_a?(Array)
        message.document.each do |doc|
          @storage.write_to_files_table(doc.file_id, @group_id)
        end
      else
        @storage.write_to_files_table(message.document.file_id, @group_id)
      end
    end

    if message.text == COMMANDS[:done]
      send_message(bot, message, "Группа создана. Файлы сохранены.")
      @state = STATES[:normal]
    end

    if message.reply_to_message
      @storage.write_to_groups_table(message.text)
      @group_id = @storage.get_group_id_by_name(message.text)
      send_message(bot, message, "Отправляйте файлы. Закончили? Вызывайте /done")
    end
  end

  def send_message(bot, message, text, options = {})
    # разобраться почему from.id работает и с колбэк и с мэсседж
    bot.api.send_message(chat_id: message.from.id, text: text, **options)
  end
end
