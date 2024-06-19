module FolderBot
  module Commands
    module Replies
      class AddFilesReply < Command
        def call
          if @message.document.is_a?(Array)
            @message.document.each do |doc|
              Models::File.create(file_id: doc.file_id,
                                  group_id: @session[:current_group],
                                  user_id: @session.current_user.id)
            end
          else
            Models::File.create(file_id: @message.document.file_id,
                                group_id: @session[:current_group],
                                user_id: @session.current_user.id)
          end
        end
      end
    end
  end
end
