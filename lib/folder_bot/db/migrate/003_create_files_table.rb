class CreateFilesTable < FolderBot::Db::Dsl::SchemaStatements
  def change
    create_table :files do |t|
      t.column :file_id, :integer, null: false
      t.references :group_id, :groups
      t.references :user_id, :users
    end
  end
end
