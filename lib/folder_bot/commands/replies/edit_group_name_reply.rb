module FolderBot
  module Commands
    module Replies
      class EditGroupNameReply < Command
        def call
          group_name = @message.text
          FolderBot::STORAGE.edit_group_name(read(:current_group), group_name)
          save :current_group, FolderBot::STORAGE.get_group_id_by_name(group_name)
          keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
          current_bot_message = send_message(@bot, @message, 'Имя успешно изменено!', reply_markup: keyboard)
          save :current_message, { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
