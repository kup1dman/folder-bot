module FolderBot
  module Models
    class File
      attr_accessor :id, :file_id, :group_id, :user_id

      def initialize(id: nil, file_id: nil, group_id: nil, user_id: nil)
        @id = id
        @file_id = file_id
        @group_id = group_id
        @user_id = user_id
      end

      def save
        FolderBot::ADAPTER.execute 'INSERT INTO files (file_id, group_id, user_id) VALUES (?, ?, ?)', file_id, group_id, user_id
        self.id = FolderBot::ADAPTER.execute('SELECT last_insert_rowid() FROM files')[0][0]

        self
      rescue SQLite3::ConstraintException
        false
      end

      def self.create(file_id: nil, group_id: nil, user_id: nil)
        file = File.new(file_id: file_id, group_id: group_id, user_id: user_id)
        file.save
      end

      def self.find(id)
        data = FolderBot::ADAPTER.query('SELECT * FROM files WHERE id=? LIMIT 1', id).to_a.flatten
        new(id: data[0], file_id: data[1], group_id: data[2], user_id: data[3]) unless data.empty?
      end

      def self.find_by(key, value)
        data = FolderBot::ADAPTER.query("SELECT * FROM files WHERE #{key}=? LIMIT 1", value).to_a.flatten
        new(id: data[0], file_id: data[1], group_id: data[2], user_id: data[3]) unless data.empty?
      end

      def update(**options)
        sql_options = options.map { |key, value| "#{key} = #{value}" }.join(', ')
        begin
          FolderBot::ADAPTER.execute("UPDATE files SET #{sql_options} where id=?", id)
          self.file_id, self.group_id, self.user_id = options.values_at(:file_id, :group_id, :user_id)

          self
        rescue SQLite3::SQLException
          false
        end
      end

      def delete
        FolderBot::ADAPTER.execute('DELETE FROM files WHERE id=?', id)

        true
      rescue SQLite3::SQLException
        false
      end

      def self.all
        data = FolderBot::ADAPTER.execute('SELECT * FROM files')
        data.map do |elem|
          new(id: elem[0], file_id: elem[1], group_id: elem[2], user_id: elem[3])
        end
      end

      def user
        User.find(user_id)
      end

      def group
        Group.find(group_id)
      end
    end
  end
end
