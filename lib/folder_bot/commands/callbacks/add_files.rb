module FolderBot
  module Commands
    module Callbacks
      class AddFiles < Command
        def call
          group = Models::Group.find(@message.data.scan(/group_id=([^&]+)/).flatten[0])
          @session[:current_group] = group.id

          delete_message(@bot, { message_id: @message.message.message_id, chat_id: @message.message.chat.id })
          send_message(@bot, @message, 'Отправляйте файлы. Закончили? Вызывайте /done')
          @session[:current_context] = '/add_files_reply'
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
