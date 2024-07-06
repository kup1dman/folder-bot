module FolderBot
  module Commands
    module Replies
      class CreateGroupReply < Command
        def call
          group_name = @message.text
          Models::Group.create(name: group_name, user_id: @session.current_user.id)
          keyboard = inline_keyboard(['Список групп'], ['/list_of_groups'],
                                     back_button: { text: '« Назад в Меню', callback_data: '/menu'})
          send_message(@bot, @message, 'Группа создана!', reply_markup: keyboard)
          # @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }

          @session.clear :current_context
        end
      end
    end
  end
end
