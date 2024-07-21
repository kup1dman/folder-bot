module FolderBot
  module Commands
    module Messages
      class Done < Command
        def call
          if @session[:current_context] == '/add_files_reply'
            keyboard = inline_keyboard(back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
            send_message(@bot, @message, 'Файлы сохранены.', reply_markup: keyboard)
            @session.clear :current_context
          else
            send_message(@bot, @message, 'Начните отправлять файлы.')
          end
        end
      end
    end
  end
end
