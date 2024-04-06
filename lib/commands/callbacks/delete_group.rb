class DeleteGroup < Command
  def call
    STORAGE.delete_group(REDIS.hget('current-group', 'id'))
    keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
    current_bot_message = edit_message(@bot,
                                       REDIS.hget('current-message', 'message-id'),
                                       REDIS.hget('current-message', 'chat-id'),
                                       'Группа удалена!',
                                       reply_markup: keyboard)
    REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
  end
end
