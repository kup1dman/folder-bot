require 'sqlite3'

namespace :db do
  task :migrate do
    Dir.glob('lib/folder_bot/db/dsl/*.rb').sort.each do |file|
      require_relative file
    end

    Dir.glob('lib/folder_bot/db/migrate/*.rb').sort.each do |file|
      require_relative file
    end

    FolderBot::MiniRecord::Dsl::SchemaStatements.subclasses.each { |subclass| subclass.new.change }

    puts 'Migrations successfully applied.'
  end
end
