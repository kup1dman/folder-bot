module FolderBot
  module Commands
    class Command
      include Helpers::InlineHelper
      include Helpers::ApiHelper
      include Helpers::MediaHelper

      def initialize(bot, message, session)
        @bot = bot
        @message = message
        @session = session
      end
    end
  end
end
