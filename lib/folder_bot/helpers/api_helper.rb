module FolderBot
  module Helpers
    module ApiHelper
      def send_message(bot, message, text, options = {})
        bot.api.send_message(chat_id: message.from.id, text: text, **options)
      end

      def edit_message(bot, message, text, options = {})
        bot.api.edit_message_text(chat_id: message[:chat_id], message_id: message[:message_id], text: text, **options)
      end

      def delete_message(bot, message)
        bot.api.delete_message(chat_id: message[:chat_id], message_id: message[:message_id])
      end

      def delete_messages(bot, chat_id, messages)
        bot.api.delete_messages(chat_id: chat_id, message_ids: messages)
      end
    end
  end
end
