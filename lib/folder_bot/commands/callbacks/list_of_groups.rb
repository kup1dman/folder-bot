module FolderBot
  module Commands
    module Callbacks
      class ListOfGroups < Command
        def call
          names = FolderBot::STORAGE.group_names
          callback_dates = names.map { |name| "/pick_#{name.gsub(' ', '_')}" }
          keyboard = inline_keyboard(names, callback_dates, back_button: { text: '« Назад в меню', callback_data: '/menu' })
          current_bot_message = edit_message(@bot, @session[:current_message], 'Выберите группу', reply_markup: keyboard)
          @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
