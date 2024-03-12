class Client
  COMMANDS = {
    menu: '/menu',
    group_files: '/group_files',
    done: '/done',
    create_group: '/create_group',
    list_of_groups: '/list_of_groups',
    add_files: '/add_files',
    back: '/back'
  }

  STATES = {
    normal: 0,
    sending_files: 1
  }

  def initialize
    @storage = Storage.new
    @state = STATES[:normal]
    @current_group_id = nil #плохо
  end

  def start
    Telegram::Bot::Client.run(ENV["TOKEN"]) { |bot| listen_to_messages(bot) }
  end

  private

  def listen_to_messages(bot)
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::Message
        case message.text
        when COMMANDS[:menu]
          keyboard = create_inline_keyboard(2, ["Создать группу", "Список групп"], [COMMANDS[:create_group], COMMANDS[:list_of_groups]])
          send_message(bot, message, "Привет. Что хотите сделать", reply_markup: keyboard)
        else
          handle_replies(bot, message)
          process_sending_files(bot, message) if STATES[:sending_files]
        end
      when Telegram::Bot::Types::CallbackQuery
        case message.data
        when COMMANDS[:create_group]
          send_message(bot, message, "Назовите группу", reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
        when COMMANDS[:list_of_groups]
          names = @storage.get_group_names
          callback_dates = names.map { |name| "/pick_#{name.gsub(' ', '_')}" }
          keyboard = create_inline_keyboard(names.count, names, callback_dates)
          send_message(bot, message, "Выберите группу", reply_markup: keyboard)
        when /^\/pick_\w+$/
          group_name = message.data[6..].gsub('_', ' ') #плохо
          @current_group_id = @storage.get_group_id_by_name(group_name)
          prepare_group_info(bot, message, group_name)
        when COMMANDS[:add_files]
          send_message(bot, message, "Отправляйте файлы. Закончили? Вызывайте /done")
          @state = STATES[:sending_files]
        end
      end
    end
  end

  def handle_replies(bot, message)
    return if message.reply_to_message.nil?

    case message.reply_to_message.text
    when "Назовите группу"
      group_name = message.text
      @storage.write_to_groups_table(group_name)
      send_message(bot, message, "Группа создана!")
      @current_group_id = @storage.get_group_id_by_name(group_name)
      prepare_group_info(bot, message, group_name)
    end
  end

  def prepare_group_info(bot, message, group_name)
    send_message(bot, message, "Группа #{group_name}")
    file_ids = @storage.get_file_ids_by(@storage.get_group_id_by_name(group_name))
    if file_ids.empty?
      send_message(bot, message, "Пока тут пусто")
    else
      send_media_group(bot, message, create_input_media_document(file_ids))
    end
    keyboard = create_inline_keyboard(2, ["Добавить файлы", "Назад"], [COMMANDS[:add_files], COMMANDS[:back]])
    send_message(bot, message, "Список действий", reply_markup: keyboard)
  end

  def create_input_media_document(file_ids)
    file_ids.map { |file_id| Telegram::Bot::Types::InputMediaDocument.new(type: 'document', media: file_id) }
  end

  def create_inline_keyboard(button_count, button_texts, callback_dates)
    kb = create_inline_buttons(button_count, button_texts, callback_dates)
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: [kb])
  end

  def create_inline_buttons(button_count, button_texts, callback_dates)
    kb = []
    button_count.times do |i|
      kb.push(Telegram::Bot::Types::InlineKeyboardButton.new(text: button_texts[i], callback_data: callback_dates[i]))
    end
    kb
  end

  def process_sending_files(bot, message)
    if message.document
      if message.document.is_a?(Array)
        message.document.each do |doc|
          @storage.write_to_files_table(doc.file_id, @current_group_id)
        end
      else
        @storage.write_to_files_table(message.document.file_id, @current_group_id)
      end
    end

    if message.text == COMMANDS[:done]
      send_message(bot, message, "Файлы сохранены.")
      @state = STATES[:normal]
    end
  end

  def send_message(bot, message, text, options = {})
    # разобраться почему from.id работает и с колбэк и с мэсседж
    bot.api.send_message(chat_id: message.from.id, text: text, **options)
  end

  def send_media_group(bot, message, media)
    bot.api.send_media_group(chat_id: message.from.id, media: media)
  end
end
