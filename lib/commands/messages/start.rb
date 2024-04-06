class Start < Command
  def call
    keyboard = inline_keyboard(['Меню'], ['/menu'])
    current_bot_message = send_message(@bot, @message, 'Привет, я FolderBot', reply_markup: keyboard)
    REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
  end
end
