module FolderBot
  module Commands
    module Callbacks
      class EditGroupName < Command
        def call
          group = Models::Group.find(@message.data.scan(/group_id=([^&]+)/).flatten[0])
          @session[:current_group] = group.id

          delete_message(@bot, { message_id: @message.message.message_id, chat_id: @message.message.chat.id })
          @session[:current_context] = '/edit_group_name_reply'
          send_message(@bot,
                       @message,
                       'Введите новое имя группы',
                       reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
