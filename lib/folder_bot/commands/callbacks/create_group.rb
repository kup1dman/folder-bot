module FolderBot
  module Commands
    module Callbacks
      class CreateGroup < Command
        def call
          send_message(@bot,
                       @message,
                       'Назовите группу',
                       reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
          @session[:current_context] = '/create_group_reply'
          delete_message(@bot, @session[:current_message])
        end
      end
    end
  end
end
