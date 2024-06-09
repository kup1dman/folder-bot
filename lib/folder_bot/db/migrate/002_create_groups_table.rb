class CreateGroupsTable < FolderBot::Db::Dsl::SchemaStatements
  def change
    create_table :groups do |t|
      t.column :name, :string, null: false, unique: true
      t.references :user_id, :users
    end
  end
end
