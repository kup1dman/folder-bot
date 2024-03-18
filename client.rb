class Client
  COMMANDS = {
    start: '/start',
    menu: '/menu',
    group_files: '/group_files',
    done: '/done',
    create_group: '/create_group',
    edit_name_group: '/edit_name_group',
    delete_group: '/delete_group',
    list_of_groups: '/list_of_groups',
    add_files: '/add_files',
    back: '/back',
  }

  STATES = {
    normal: 0,
    sending_files: 1
  }

  def initialize
    @storage = Storage.new
    @state = State.new
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
        when COMMANDS[:start]
          keyboard = create_inline_keyboard(["Меню"], [COMMANDS[:menu]])
          current_bot_message = send_message(bot, message, "Привет, я FolderBot", reply_markup: keyboard)
          @state.set_current_message(current_bot_message)
        else
          handle_replies(bot, message)
          process_sending_files(bot, message) if @state.current_process == STATES[:sending_files]
        end
      when Telegram::Bot::Types::CallbackQuery
        case message.data
        when COMMANDS[:menu]
          keyboard = create_inline_keyboard(["Создать группу", "Список групп"],
                                            [COMMANDS[:create_group], COMMANDS[:list_of_groups]])
          current_bot_message = edit_message(bot, @state.current_message, "Что хотите сделать", reply_markup: keyboard)
          @state.set_current_message(current_bot_message)
        when COMMANDS[:create_group]
          delete_message(bot, @state.current_message)
          send_message(bot, message, "Назовите группу", reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
        when COMMANDS[:list_of_groups]
          names = @storage.get_group_names
          callback_dates = names.map { |name| "/pick_#{name.gsub(' ', '_')}" }
          keyboard = create_inline_keyboard(names,
                                            callback_dates,
                                            back_button: { text: "« Назад в меню", callback_data: COMMANDS[:menu]})
          current_bot_message = edit_message(bot, @state.current_message, "Выберите группу", reply_markup: keyboard)
          @state.set_current_message(current_bot_message)
        when /^\/pick_\w+$/
          delete_message(bot, @state.current_message)
          group_name = message.data[6..].gsub('_', ' ') #плохо
          @state.set_current_group(@storage.get_group_id_by_name(group_name))
          prepare_group_info(bot, message, group_name)
        when COMMANDS[:add_files]
          delete_message(bot, @state.current_message)
          send_message(bot, message, "Отправляйте файлы. Закончили? Вызывайте /done")
          @state.set_current_process(STATES[:sending_files])
        when COMMANDS[:edit_name_group]
          delete_message(bot, @state.current_message)
          send_message(bot, message, "Введите новое имя группы", reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
        when COMMANDS[:delete_group]
          @storage.delete_group(@state.current_group)
          keyboard = create_inline_keyboard(back_button: { text: "« Назад в список групп", callback_data: COMMANDS[:list_of_groups]})
          current_bot_message = edit_message(bot, @state.current_message, "Группа удалена!", reply_markup: keyboard)
          @state.set_current_message(current_bot_message)
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
      @state.set_current_group(@storage.get_group_id_by_name(group_name))
      send_message(bot, message, "Группа создана!")
      prepare_group_info(bot, message, group_name)
    when "Введите новое имя группы"
      group_name = message.text
      @storage.edit_group_name(@state.current_group, group_name)
      keyboard = create_inline_keyboard(back_button: { text: "« Назад в список групп", callback_data: COMMANDS[:list_of_groups]})
      current_bot_message = send_message(bot, message, "Имя успешно изменено!", reply_markup: keyboard)
      @state.set_current_message(current_bot_message)
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
    keyboard = create_inline_keyboard(["Добавить файлы", "Изменить имя группы", "Удалить группу"],
                                      [COMMANDS[:add_files], COMMANDS[:edit_name_group], COMMANDS[:delete_group]],
                                      back_button: { text: "« Назад в список групп", callback_data: COMMANDS[:list_of_groups]})
    current_bot_message = send_message(bot, message, "Список действий", reply_markup: keyboard)
    @state.set_current_message(current_bot_message)
  end

  def create_input_media_document(file_ids)
    file_ids.map { |file_id| Telegram::Bot::Types::InputMediaDocument.new(type: 'document', media: file_id) }
  end

  def create_inline_keyboard(button_texts = nil, callback_dates = nil, back_button: {})
    kb = []
    unless button_texts.nil? && callback_dates.nil?
      button_texts.size.times do |i|
        button = create_inline_button(button_texts[i], callback_dates[i])
        kb.push(button)
      end
      kb = kb.each_slice(2).to_a
    end

    unless back_button.empty?
      back_button = [create_inline_button(back_button[:text], back_button[:callback_data])]
      kb.push(back_button)
    end
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
  end

  def create_inline_button(button_text, callback_date)
    Telegram::Bot::Types::InlineKeyboardButton.new(text: button_text, callback_data: callback_date)
  end

  def process_sending_files(bot, message)
    if message.document
      if message.document.is_a?(Array)
        message.document.each do |doc|
          @storage.write_to_files_table(doc.file_id, @state.current_group)
        end
      else
        @storage.write_to_files_table(message.document.file_id, @state.current_group)
      end
    end

    if message.text == COMMANDS[:done]
      keyboard = create_inline_keyboard(back_button: { text: "« Назад в список групп", callback_data: COMMANDS[:list_of_groups]})
      current_bot_message = send_message(bot, message, "Файлы сохранены.", reply_markup: keyboard)
      @state.set_current_message(current_bot_message)
      @state.set_current_process(STATES[:normal])
    end
  end

  def send_message(bot, message, text, options = {})
    # разобраться почему from.id работает и с колбэк и с мэсседж
    bot.api.send_message(chat_id: message.from.id, text: text, **options)
  end

  def edit_message(bot, message, text, options = {})
    return if message.nil?

    bot.api.edit_message_text(chat_id: message.chat.id, message_id: message.message_id, text: text, **options)
  end

  def delete_message(bot, message)
    bot.api.delete_message(chat_id: message.chat.id, message_id: message.message_id)
  end

  def send_media_group(bot, message, media)
    bot.api.send_media_group(chat_id: message.from.id, media: media)
  end
end
