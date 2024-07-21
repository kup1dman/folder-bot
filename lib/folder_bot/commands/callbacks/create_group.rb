module FolderBot
  module Commands
    module Callbacks
      class CreateGroup < Command
        def call
          delete_message(@bot, { message_id: @message.message.message_id, chat_id: @message.message.chat.id })
          send_message(@bot,
                       @message,
                       'Назовите группу (Лимит 20 символов)',
                       reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
          @session[:current_context] = '/create_group_reply'
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
