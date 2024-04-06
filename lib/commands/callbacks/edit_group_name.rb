class EditGroupName < Command
  def call
    delete_message(@bot,
                   REDIS.hget('current-message', 'message-id'),
                   REDIS.hget('current-message', 'chat-id'))
    send_message(@bot,
                 @message,
                 'Введите новое имя группы',
                 reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
  end
end
