module FolderBot
  module Commands
    module Messages
      class Start < Command
        def call
          keyboard = inline_keyboard(['Меню'], ['/menu'])
          current_bot_message = send_message(@bot, @message, 'Привет, я FolderBot', reply_markup: keyboard)
          save :current_message, { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
