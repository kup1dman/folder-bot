module FolderBot
  module Commands
    module Replies
      class AddFilesReply < Command
        def call
          files = []
          files << @message.document if @message.document
          files << @message.photo.min { |subphoto| subphoto.file_size } if @message.photo
          files.flatten.each do |file|
            Models::File.create(file_id: file.file_id,
                                type: file.class.to_s.split('::').last.downcase,
                                group_id: @session[:current_group],
                                user_id: @session.current_user.id)
          end
          files
        end
      end
    end
  end
end
