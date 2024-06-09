module FolderBot
  module Commands
    module Replies
      class AddFilesReply < Command
        def call
          if @message.document.is_a?(Array)
            @message.document.each { |doc| STORAGE.write_to_files_table(doc.file_id, @session[:current_group]) }
            # @message.document.each { |doc| doc.create(file_id: doc.file_id, group_id: @session[:current_group].id) }
          else
            FolderBot::STORAGE.write_to_files_table(@message.document.file_id, @session[:current_group])
            # File.create(file_id: @message.document.file_id, group_id: @session[:current_group].id)
          end
        end
      end
    end
  end
end
