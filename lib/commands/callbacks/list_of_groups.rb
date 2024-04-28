class ListOfGroups < Command
  def call
    names = App::STORAGE.group_names
    callback_dates = names.map { |name| "/pick_#{name.gsub(' ', '_')}" }
    keyboard = inline_keyboard(names, callback_dates, back_button: { text: '« Назад в меню', callback_data: '/menu' })
    current_bot_message = edit_message(@bot, read(:current_message), 'Выберите группу', reply_markup: keyboard)
    save :current_message, { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
  end
end
