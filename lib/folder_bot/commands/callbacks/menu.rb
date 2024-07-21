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
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
