module FolderBot
  module Models
    class Model
      def initialize
        @adapter = SQLite3::Database.new 'bot.db'
      end

      # def self.create(**attrs)
      #   columns = attrs.keys.join(', ')
      #   questions = (['?'] * attrs.keys.count).join(', ')
      #   @adapter.execute "INSERT INTO #{self.class.to_s.downcase}s (#{columns}) VALUES (#{questions})", attrs.values
      # end
      #
      # def find_by(attr)
      #   @adapter.query('SELECT file_id FROM files WHERE group_id=?', group_id).to_a.flatten
      # end
    end
  end
end
