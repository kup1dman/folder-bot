class EditGroupNameReply < Command
  def call
    group_name = @message.text
    STORAGE.edit_group_name(REDIS.hget('current-group', 'id'), group_name)
    REDIS.hset('current_group', 'id', STORAGE.get_group_id_by_name(group_name))
    keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
    current_bot_message = send_message(@bot, @message, 'Имя успешно изменено!', reply_markup: keyboard)
    REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
  end
end
