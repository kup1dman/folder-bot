module FolderBot
  module Commands
    module Callbacks
      class DeleteGroup < Command
        def call
          group_name = @message.data.scan(/group_name=([^&]+)/).flatten[0]
          Models::Group.find_by(:name, group_name).delete

          keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
          edit_message(
            @bot,
            { message_id: @message.message.message_id, chat_id: @message.message.chat.id },
            'Группа удалена!',
            reply_markup: keyboard
          )
          # @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
