module FolderBot
  module MiniRecord
    module Dsl
      class Base
        def initialize
          @adapter = SQLite3::Database.new 'bot.db'
        end
      end
    end
  end
end
