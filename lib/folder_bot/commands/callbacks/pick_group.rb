module FolderBot
  module Commands
    module Callbacks
      class PickGroup < Command
        def call
          delete_message(@bot, { message_id: @message.message.message_id, chat_id: @message.message.chat.id })
          group = Models::Group.find(@message.data.scan(/group_id=([^&]+)/).flatten[0])

          send_message(@bot, @message, "Группа #{group.name}")
          file_ids = group.files.map(&:file_id)
          file_types = group.files.map(&:type)
          files = file_ids.zip(file_types).to_h
          if files.empty?
            send_message(@bot, @message, 'Пока тут пусто')
          else
            send_media_group(@bot, @message, create_input_media_document(files))
          end

          keyboard = inline_keyboard(['Добавить файлы', 'Изменить имя группы', 'Удалить группу'],
                                     [
                                       "/add_files?group_id=#{group.id}",
                                       "/edit_group_name?group_id=#{group.id}",
                                       "/delete_group?group_id=#{group.id}"
                                     ],
                                     back_button: { text: '« Назад в список групп', callback_data: '/list_of_groups' })
          send_message(@bot, @message, 'Список действий', reply_markup: keyboard)
        rescue Telegram::Bot::Exceptions::ResponseError => e
          e.error_code
        end
      end
    end
  end
end
