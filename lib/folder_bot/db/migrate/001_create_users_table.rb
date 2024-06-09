class CreateUsersTable < FolderBot::Db::Dsl::SchemaStatements
  def change
    create_table :users
  end
end
