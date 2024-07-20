module FolderBot
  module Db
    module Dsl
      class SchemaDefinition
        TYPES = {
          integer: 'INTEGER',
          string: 'VARCHAR(64)',
        }.freeze

        OPTIONS = {
          { primary_key: true } => 'PRIMARY KEY',
          { null: false } => 'NOT NULL',
          { unique: true } => 'UNIQUE',
        }.freeze

        def initialize(table_name)
          @table_name = table_name
          @columns = []
          @foreign_keys = []
          column(:id, :integer, primary_key: true, null: false)
        end

        def column(name, type, **options)
          sql_column = "#{name} #{TYPES[type]} #{sql_options(options)}"
          @columns << sql_column
        end

        def references(column_name, ref_table)
          column(column_name, :integer)
          sql_ref = "FOREIGN KEY (#{column_name}) REFERENCES #{ref_table}(id)"
          @foreign_keys << sql_ref
        end

        def create_table
          sql_table = "CREATE TABLE IF NOT EXISTS #{@table_name} (
          #{@columns.concat(@foreign_keys).join(', ')}
        )"
          FolderBot::ADAPTER.execute sql_table
        end

        def sql_options(options)
          return if options.empty?

          options.map do |key, value|
            OPTIONS[{ key => value }]
          end.join(' ')
        end
      end
    end
  end
end
