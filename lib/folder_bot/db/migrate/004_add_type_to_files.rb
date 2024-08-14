class CreateFilesTable < FolderBot::Db::Dsl::SchemaStatements
  def change
    add_column :files, :type, :string, null: false
  end
end
