class Menu < Command
  def call
    keyboard = inline_keyboard(['Создать группу', 'Список групп'], %w[/create_group /list_of_groups])
    current_bot_message = edit_message(@bot,
                                       REDIS.hget('current-message', 'message-id'),
                                       REDIS.hget('current-message', 'chat-id'),
                                       'Что хотите сделать',
                                       reply_markup: keyboard)
    REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
  end
end
