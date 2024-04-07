class ListOfGroups < Command
  def call
    names = App::STORAGE.group_names
    callback_dates = names.map { |name| "/pick_#{name.gsub(' ', '_')}" }
    keyboard = inline_keyboard(names, callback_dates, back_button: { text: '« Назад в меню', callback_data: '/menu' })
    current_bot_message = edit_message(@bot,
                                       App::REDIS.hget('current-message', 'message-id'),
                                       App::REDIS.hget('current-message', 'chat-id'),
                                       'Выберите группу',
                                       reply_markup: keyboard)
    App::REDIS.hset('current-message',
               'message-id', current_bot_message.message_id, 'chat-id', current_bot_message.chat.id)
  end
end
