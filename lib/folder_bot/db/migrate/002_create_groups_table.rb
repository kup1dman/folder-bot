class CreateGroupsTable < Migration
  def change
    @adapter.execute <<-SQL
      CREATE TABLE IF NOT EXISTS groups(
        id INTEGER PRIMARY KEY NOT NULL,
        name VARCHAR(64) NOT NULL
      )
    SQL
  end
end
