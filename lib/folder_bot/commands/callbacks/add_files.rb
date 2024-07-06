module FolderBot
  module Commands
    module Callbacks
      class AddFiles < Command
        def call
          delete_message(@bot, { message_id: @message.message.message_id, chat_id: @message.message.chat.id })
          send_message(@bot, @message, 'Отправляйте файлы. Закончили? Вызывайте /done')
          @session[:current_context] = '/add_files_reply'
        end
      end
    end
  end
end
