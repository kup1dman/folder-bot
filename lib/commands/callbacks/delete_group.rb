class DeleteGroup < Command
  def call
    App::STORAGE.delete_group(App::REDIS.hget('current-group', 'id'))
    keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
    current_bot_message = edit_message(@bot,
                                       App::REDIS.hget('current-message', 'message-id'),
                                       App::REDIS.hget('current-message', 'chat-id'),
                                       'Группа удалена!',
                                       reply_markup: keyboard)
    App::REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
  end
end
