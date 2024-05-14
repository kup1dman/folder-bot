namespace :db do
  task :migrate do
    require_relative 'lib/folder_bot/db/migration'
    migration_files = Dir.glob('lib/folder_bot/db/migrate/*.rb').sort
    migration_files.each do |file|
      require_relative file
    end

    Migration.subclasses.each { |subclass| subclass.new.change }

    puts 'Migrations successfully applied.'
  end
end
