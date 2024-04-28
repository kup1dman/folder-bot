class Done < Command
  def call
    keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
    current_bot_message = send_message(@bot, @message, 'Файлы сохранены.', reply_markup: keyboard)
    save :current_message, { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
  end
end
