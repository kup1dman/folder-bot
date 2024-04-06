class CreateGroup < Command
  def call
    send_message(@bot,
                 @message,
                 'Назовите группу',
                 reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
    delete_message(@bot,
                   REDIS.hget('current-message', 'message-id'),
                   REDIS.hget('current-message', 'chat-id'))
  end
end
