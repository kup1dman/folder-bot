class CreateGroupsTable < FolderBot::Db::Dsl::SchemaStatements
  def change
    create_table :groups do |t|
      t.column :name, :string, null: false, unique: true # ебаный sqlite не имеет лимита для текста, ему похую на varchar(20)
      t.references :user_id, :users
    end
  end
end
