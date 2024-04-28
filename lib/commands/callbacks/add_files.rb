class AddFiles < Command
  def call
    delete_message(@bot, read(:current_message))
    send_message(@bot, @message, 'Отправляйте файлы. Закончили? Вызывайте /done')
    save :current_process, :sending_files
  end
end
