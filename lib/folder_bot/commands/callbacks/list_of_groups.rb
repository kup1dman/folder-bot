module FolderBot
  module Commands
    module Callbacks
      class ListOfGroups < Command
        def call
          names = @session.current_user.groups.map(&:name)
          callback_dates = names.map { |name| "/pick_group?group_name=#{name}&" }
          keyboard = inline_keyboard(names, callback_dates,
                                     back_button: { text: '« Назад в меню', callback_data: '/menu' })
          edit_message(
            @bot,
            { message_id: @message.message.message_id, chat_id: @message.message.chat.id },
            'Выберите группу',
            reply_markup: keyboard
          )
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
