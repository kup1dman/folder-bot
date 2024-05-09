module FolderBot
  module Commands
    module Messages
      class Start < Command
        def call
          if @session[:current_context] == '/add_files_reply' # костыль
            return send_message(@bot, @message, 'Закончите отправку файлов командой /done')
          end

          keyboard = inline_keyboard(['Меню'], ['/menu'])
          current_bot_message = send_message(@bot, @message, 'Привет, я FolderBot', reply_markup: keyboard)
          @session[:current_message] = { message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id }
        end
      end
    end
  end
end
