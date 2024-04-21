class DeleteGroup < Command
  def call
    App::STORAGE.delete_group(group)
    keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
    current_bot_message = edit_message(@bot, message, 'Группа удалена!', reply_markup: keyboard)
    save_message message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id
  end
end
