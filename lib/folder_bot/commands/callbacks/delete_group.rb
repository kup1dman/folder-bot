module FolderBot
  module Commands
    module Callbacks
      class DeleteGroup < Command
        def call
          Models::Group.find(@message.data.scan(/group_id=([^&]+)/).flatten[0])&.delete

          keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
          edit_message(
            @bot,
            { message_id: @message.message.message_id, chat_id: @message.message.chat.id },
            'Группа удалена!',
            reply_markup: keyboard
          )
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
