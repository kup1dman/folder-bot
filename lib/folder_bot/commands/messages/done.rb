module FolderBot
  module Commands
    module Messages
      class Done < Command
        def call
          if @session[:current_context] == '/add_files_reply'
            group_name = Models::Group.find(@session[:current_group]).name
            keyboard = inline_keyboard(back_button: { text: '« Назад в группу',
                                                      callback_data: "/pick_group?group_id=#{@session[:current_group]}" })
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
