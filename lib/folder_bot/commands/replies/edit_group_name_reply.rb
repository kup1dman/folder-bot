module FolderBot
  module Commands
    module Replies
      class EditGroupNameReply < Command
        def call
          result = Models::Group.find(@session[:current_group]).update(name: @message.text)
          if result.is_a?(Models::Group)
            keyboard = inline_keyboard(back_button: { text: '« Назад в список групп',
                                                      callback_data: '/list_of_groups' })
            send_message(@bot, @message, 'Имя успешно изменено!', reply_markup: keyboard)
          else
            keyboard = inline_keyboard(['Попробуйте еще раз'],
                                       ["/edit_group_name?group_name=#{Models::Group.find(@session[:current_group]).name}"])
            send_message(@bot, @message, result.join('и '), reply_markup: keyboard)
          end

          @session.clear :current_context
          @session.clear :current_group
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
