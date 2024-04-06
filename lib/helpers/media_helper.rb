module MediaHelper
  def send_media_group(bot, message, media)
    bot.api.send_media_group(chat_id: message.from.id, media: media)
  end

  def create_input_media_document(file_ids)
    file_ids.map { |file_id| Telegram::Bot::Types::InputMediaDocument.new(type: 'document', media: file_id) }
  end
end
