module FolderBot
  module Commands
    module Callbacks
      class Menu < Command
        def call
          keyboard = inline_keyboard(['Создать группу', 'Список групп'], %w[/create_group /list_of_groups])
          edit_message(
            @bot,
            { message_id: @message.message.message_id, chat_id: @message.message.chat.id },
            'Что хотите сделать',
            reply_markup: keyboard
          )
          # @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
