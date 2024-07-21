module FolderBot
  module Commands
    module Callbacks
      class AddFiles < Command
        def call
          group_name = @message.data.scan(/group_name=([^&]+)/).flatten[0]
          group = Models::Group.find_by(:name, group_name)
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
