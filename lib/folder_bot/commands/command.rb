module FolderBot
  module Commands
    class Command
      include Session
      include Helpers::InlineHelper
      include Helpers::ApiHelper
      include Helpers::MediaHelper

      def initialize(bot, message)
        @bot = bot
        @message = message
      end
    end
  end
end
