module FolderBot
  module Commands
    module Replies
      class AddFilesReply < Command
        def call
          if @message.document.is_a?(Array)
            @message.document.each { |doc| STORAGE.write_to_files_table(doc.file_id, @session[:current_group]) }
          else
            FolderBot::STORAGE.write_to_files_table(@message.document.file_id, @session[:current_group])
          end
        end
      end
    end
  end
end
