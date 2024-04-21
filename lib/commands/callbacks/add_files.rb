class AddFiles < Command
  def call
    delete_message(@bot, message)
    send_message(@bot, @message, 'Отправляйте файлы. Закончили? Вызывайте /done')
    App::REDIS.set('current-process', Client::STATES[:sending_files].to_s)
  end
end
