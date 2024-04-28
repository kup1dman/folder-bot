class AddFilesReply < Command
  def call
    if @message.document.is_a?(Array)
      @message.document.each { |doc| App::STORAGE.write_to_files_table(doc.file_id, read(:current_group)) }
    else
      App::STORAGE.write_to_files_table(@message.document.file_id, read(:current_group))
    end
  end
end
