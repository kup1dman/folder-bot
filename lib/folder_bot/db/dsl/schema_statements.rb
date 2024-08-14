module FolderBot
  module Db
    module Dsl
      class SchemaStatements
        def create_table(name)
          td = SchemaDefinition.new(name)
          yield td if block_given?
          td.create_table
        end

        def add_column(table_name, column_name, column_type, **options)
          td = SchemaDefinition.new(table_name)
          td.add_column(column_name, column_type, options)
        end
      end
    end
  end
end
