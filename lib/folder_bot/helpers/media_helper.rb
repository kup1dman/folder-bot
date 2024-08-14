module FolderBot
  module Helpers
    module MediaHelper
      def send_media_group(bot, message, media)
        media.each_value do |arr|
          bot.api.send_media_group(chat_id: message.from.id, media: arr) unless arr.empty?
        end
      end

      def create_input_media_document(files)
        media = { document: [], photo: [] }
        files.each do |file_id, file_type|
          case file_type
          when 'document'
            media[:document] << Telegram::Bot::Types::InputMediaDocument.new(type: file_type, media: file_id)
          when 'photosize'
            media[:photo] << Telegram::Bot::Types::InputMediaPhoto.new(type: 'photo', media: file_id)
          end
        end
        media
      end
    end
  end
end
