module FolderBot
  module Models
    class User
      attr_accessor :id, :tg_uid

      def initialize(id: nil, tg_uid: nil)
        @id = id
        @tg_uid = tg_uid
      end

      def save
        FolderBot::ADAPTER.execute 'INSERT INTO users (tg_uid) VALUES (?)', tg_uid
        self.id = FolderBot::ADAPTER.execute('SELECT last_insert_rowid() FROM users')[0][0]

        self
      rescue SQLite3::ConstraintException
        false
      end

      def self.create(tg_uid: nil)
        User.new(tg_uid: tg_uid).save
      end

      def self.find(id)
        data = FolderBot::ADAPTER.query('SELECT * FROM users WHERE id=? LIMIT 1', id).to_a.flatten
        new(id: data[0]) unless data.empty?
      end

      def self.find_by(key, value)
        data = FolderBot::ADAPTER.query("SELECT * FROM users WHERE #{key}=? LIMIT 1", value).to_a.flatten
        new(id: data[0], tg_uid: data[1]) unless data.empty?
      end

      # no update method because of no such attr in table

      def delete
        FolderBot::ADAPTER.execute('DELETE FROM users  WHERE id=?', id)

        true
      rescue SQLite3::SQLException
        false
      end

      def self.all
        data = FolderBot::ADAPTER.execute('SELECT * FROM users')
        data.map do |elem|
          new(id: elem[0])
        end
      end

      def groups
        data = FolderBot::ADAPTER.execute('SELECT * FROM groups WHERE user_id=?', id)
        data.map do |elem|
          Group.new(id: elem[0], name: elem[1], user_id: elem[2])
        end
      end

      def files
        data = FolderBot::ADAPTER.execute('SELECT * FROM files WHERE user_id=?', id)
        data.map do |elem|
          File.new(id: elem[0], file_id: elem[1], group_id: elem[2], user_id: elem[3])
        end
      end
    end
  end
end
