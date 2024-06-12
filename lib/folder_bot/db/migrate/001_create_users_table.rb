class CreateUsersTable < FolderBot::Db::Dsl::SchemaStatements
  def change
    create_table :users do |t|
      t.column :tg_uid, :string, null: false
    end
  end
end
