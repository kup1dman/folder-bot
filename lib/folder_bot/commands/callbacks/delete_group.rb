module FolderBot
  module Commands
    module Callbacks
      class DeleteGroup < Command
        def call
          FolderBot::STORAGE.delete_group(@session[:current_group])
          keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
          current_bot_message = edit_message(@bot, @session[:current_message], 'Группа удалена!', reply_markup: keyboard)
          @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
