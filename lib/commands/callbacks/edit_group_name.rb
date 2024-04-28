class EditGroupName < Command
  def call
    delete_message(@bot, read(:current_message))
    save :current_context, '/edit_group_name_reply'
    send_message(@bot,
                 @message,
                 'Введите новое имя группы',
                 reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
  end
end
