class PickGroup < Command
  def call
    delete_message(@bot,
                   App::REDIS.hget('current-message', 'message-id'),
                   App::REDIS.hget('current-message', 'chat-id'))
    group_name = @message.data[6..].gsub('_', ' ') # плохо
    App::REDIS.hset('current-group', 'id', App::STORAGE.get_group_id_by_name(group_name))
    group_info(@bot, @message, group_name)
  end

  def group_info(bot, message, group_name)
    send_message(bot, message, "Группа #{group_name}")
    files(bot, message, group_name)
    keyboard = inline_keyboard(['Добавить файлы', 'Изменить имя группы', 'Удалить группу'],
                               %w[/add_files /edit_group_name /delete_group],
                               back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups'})
    current_bot_message = send_message(bot, message, 'Список действий', reply_markup: keyboard)
    App::REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
  end

  def files(bot, message, group_name)
    file_ids = App::STORAGE.get_file_ids_by(App::STORAGE.get_group_id_by_name(group_name))
    if file_ids.empty?
      send_message(bot, message, 'Пока тут пусто')
    else
      send_media_group(bot, message, create_input_media_document(file_ids))
    end
  end
end