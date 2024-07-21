module FolderBot
  module Commands
    module Replies
      class CreateGroupReply < Command
        def call
          group_name = @message.text
          result = Models::Group.create(name: group_name, user_id: @session.current_user.id)
          if result.is_a?(Models::Group)
            keyboard = inline_keyboard(['Список групп'], ['/list_of_groups'],
                                       back_button: { text: '« Назад в Меню', callback_data: '/menu' })
            send_message(@bot, @message, 'Группа создана!', reply_markup: keyboard)
          else
            keyboard = inline_keyboard(['Попробуйте еще раз'], ['/create_group'])
            send_message(@bot, @message, result.join('и '), reply_markup: keyboard)
          end

          @session.clear :current_context
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
