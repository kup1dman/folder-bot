require 'sqlite3'

module Database
  attr_accessor :db

  def self.setup
    self.db = SQLite3::Database.open 'bot.db'
    db.execute "CREATE TABLE IF NOT EXISTS files(file_id INT, group TEXT)"
  end

  def update_table(file_id, group: nil)
    db.execute "UPDATE files SET file_id=? AND group=?", file_id, group
  end

  def self.get_file_ids_by(group)
    db.query "SELECT file_id, FROM files WHERE group=?", group
  end
end


