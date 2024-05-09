module FolderBot
  module Commands
    module Replies
      class CreateGroupReply < Command
        def call
          group_name = @message.text
          FolderBot::STORAGE.write_to_groups_table(group_name)
          send_message(@bot, @message, 'Группа создана!')
          Callbacks::PickGroup.new(@bot, @message, @session).group_info(@bot, @message, group_name) # плохо
          @session.clear :current_group
          @session.clear :current_context
        end
      end
    end
  end
end
