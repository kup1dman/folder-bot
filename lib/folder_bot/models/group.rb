module FolderBot
  module Models
    class Group
      attr_accessor :id, :name, :user_id

      def initialize(id: nil, name: nil, user_id: nil)
        @id = id
        @name = name
        @user_id = user_id
      end

      def save
        validated_name = name if name.length <= 20
        FolderBot::ADAPTER.execute 'INSERT INTO groups (name, user_id) VALUES (?, ?)', validated_name, user_id
        self.id = FolderBot::ADAPTER.execute('SELECT last_insert_rowid() FROM groups')[0][0]

        self
      rescue SQLite3::ConstraintException => e
        errors = []
        errors << 'Такое имя уже есть' if e.message.match?('UNIQUE')
        errors << 'Имя слишком длинное' if e.message.match?('NOT NULL') #кривой отлов
        errors
      end

      def self.create(name: nil, user_id: nil)
        Group.new(name: name, user_id: user_id).save
      end

      def self.find(id)
        data = FolderBot::ADAPTER.query('SELECT * FROM groups WHERE id=? LIMIT 1', id).to_a.flatten
        new(id: data[0], name: data[1], user_id: data[2]) unless data.empty?
      end

      def self.find_by(key, value)
        data = FolderBot::ADAPTER.query("SELECT * FROM groups WHERE #{key}=? LIMIT 1", value).to_a.flatten
        new(id: data[0], name: data[1], user_id: data[2]) unless data.empty?
      end

      def update(**options)
        sql_keys = options.map { |key, _| "#{key} = ?" }.join(', ')
        sql_values = options.values
        begin
          FolderBot::ADAPTER.execute("UPDATE groups SET #{sql_keys} where id=?", sql_values, id)
          options.each do |key, value|
            send("#{key}=", value) if respond_to?("#{key}=") && !value.nil?
          end

          self
        rescue SQLite3::SQLException
          false
        end
      end

      def delete
        FolderBot::ADAPTER.execute('DELETE FROM groups  WHERE id=?', id)

        true
      rescue SQLite3::SQLException
        false
      end

      def self.all
        data = FolderBot::ADAPTER.execute('SELECT * FROM groups')
        data.map do |elem|
          new(id: elem[0], name: elem[1], user_id: elem[2])
        end
      end

      def user
        User.find(user_id)
      end

      def files
        data = FolderBot::ADAPTER.execute('SELECT * FROM files WHERE group_id=?', id)
        data.map do |elem|
          File.new(id: elem[0], file_id: elem[1], group_id: elem[2], user_id: elem[3])
        end
      end
    end
  end
end
