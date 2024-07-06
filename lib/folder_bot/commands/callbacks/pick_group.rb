module FolderBot
  module Commands
    module Callbacks
      class PickGroup < Command
        def call
          delete_message(@bot, { message_id: @message.message.message_id, chat_id: @message.message.chat.id })
          group_name = @message.data[6..].gsub('_', ' ') # плохо

          send_message(@bot, @message, "Группа #{group_name}")
          group = Models::Group.find_by(:name, group_name)
          file_ids = group.files.map(&:file_id)
          @session[:current_group] = group.id
          if file_ids.empty?
            send_message(@bot, @message, 'Пока тут пусто')
          else
            send_media_group(@bot, @message, create_input_media_document(file_ids))
          end

          keyboard = inline_keyboard(['Добавить файлы', 'Изменить имя группы', 'Удалить группу'],
                                     %w[/add_files /edit_group_name /delete_group],
                                     back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups'})
          send_message(@bot, @message, 'Список действий', reply_markup: keyboard)
          # @session[:current_message] = {
          #   message_id: current_bot_message.message_id, chat_id: current_bot_message.chat.id
          # }
        end
      end

    end
  end
end
