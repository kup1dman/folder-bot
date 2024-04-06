class Done < Command
  def call
    keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
    current_bot_message = send_message(@bot, @message, 'Файлы сохранены.', reply_markup: keyboard)
    REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
    REDIS.set('current-process', Client::STATES[:normal].to_s)
  end
end
