class CreateGroup < Command
  def call
    send_message(@bot,
                 @message,
                 'Назовите группу',
                 reply_markup: Telegram::Bot::Types::ForceReply.new(force_reply: true))
    save_context :create_group_reply
    delete_message(@bot, message)
  end
end
