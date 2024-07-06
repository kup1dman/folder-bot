module FolderBot
  module Commands
    module Replies
      class EditGroupNameReply < Command
        def call
          Models::Group.find(@session[:current_group]).update(name: @message.text)
          keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
          send_message(@bot, @message, 'Имя успешно изменено!', reply_markup: keyboard)
          # @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }

          @session.clear :current_context
          @session.clear :current_group
        end
      end
    end
  end
end
