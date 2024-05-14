class CreateFilesTable < Migration
  def change
    @adapter.execute <<-SQL
      CREATE TABLE IF NOT EXISTS files(
      id INTEGER PRIMARY KEY NOT NULL,
      file_id INTEGER NOT NULL,
      group_id INTEGER,
      FOREIGN KEY (group_id) REFERENCES groups(id)
      )
    SQL
  end
end
