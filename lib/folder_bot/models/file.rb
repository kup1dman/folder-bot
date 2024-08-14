module FolderBot
  module Models
    class File
      attr_accessor :id, :file_id, :group_id, :user_id, :type

      def initialize(id: nil, file_id: nil, type: nil, group_id: nil, user_id: nil)
        @id = id
        @file_id = file_id
        @type = type
        @group_id = group_id
        @user_id = user_id
      end

      def save
        FolderBot::ADAPTER.execute 'INSERT INTO files (file_id, type, group_id, user_id) VALUES (?, ?, ?, ?)', file_id,
                                   type, group_id, user_id
        self.id = FolderBot::ADAPTER.execute('SELECT last_insert_rowid() FROM files')[0][0]

        self
      rescue SQLite3::ConstraintException
        false
      end

      def self.create(file_id: nil, type: nil, group_id: nil, user_id: nil)
        file = File.new(file_id: file_id, type: type, group_id: group_id, user_id: user_id)
        file.save
      end

      def self.find(id)
        data = FolderBot::ADAPTER.query('SELECT * FROM files WHERE id=? LIMIT 1', id).to_a.flatten
        new(id: data[0], file_id: data[1], group_id: data[2], user_id: data[3], type: data[4]) unless data.empty?
      end

      def self.find_by(key, value)
        data = FolderBot::ADAPTER.query("SELECT * FROM files WHERE #{key}=? LIMIT 1", value).to_a.flatten
        new(id: data[0], file_id: data[1], group_id: data[2], user_id: data[3], type: data[4]) unless data.empty?
      end

      def update(**options)
        sql_keys = options.map { |key, _| "#{key} = ?" }.join(', ')
        sql_values = options.values
        begin
          FolderBot::ADAPTER.execute("UPDATE files SET #{sql_keys} where id=?", sql_values, id)
          options.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=") && !value.nil?
          end

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
          new(id: elem[0], file_id: elem[1], group_id: elem[2], user_id: elem[3], type: elem[4])
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
