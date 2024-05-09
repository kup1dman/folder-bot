module FolderBot
  module Commands
    module Callbacks
      class Menu < Command
        def call
          keyboard = inline_keyboard(['Создать группу', 'Список групп'], %w[/create_group /list_of_groups])
          current_bot_message = edit_message(@bot, @session[:current_message], 'Что хотите сделать', reply_markup: keyboard)
          @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
