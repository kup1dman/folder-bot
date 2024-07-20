require_relative './lib/folder_bot'

namespace :db do
  task :migrate do
    Dir.glob('lib/folder_bot/db/migrate/*.rb').sort.each do |file|
      require_relative file
    end

    FolderBot::Db::Dsl::SchemaStatements.subclasses.reverse.each { |subclass| subclass.new.change }

    puts 'Migrations successfully applied.'
  end
end
