class CreateUsersTable < FolderBot::MiniRecord::Dsl::SchemaStatements
  def change
    create_table :users
  end
end
