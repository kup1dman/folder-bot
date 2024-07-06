module FolderBot
  module Commands
    module Callbacks
      class CreateGroup < Command
        def call
          delete_message(@bot, { message_id: @message.message.message_id, chat_id: @message.message.chat.id })
          send_message(@bot,
                       @message,
                       'Назовите группу',
                       reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
          @session[:current_context] = '/create_group_reply'
        end
      end
    end
  end
end
