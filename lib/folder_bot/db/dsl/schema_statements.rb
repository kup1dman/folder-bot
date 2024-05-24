module FolderBot
  module MiniRecord
    module Dsl
      class SchemaStatements
        def create_table(name)
          td = TableDefinition.new(name)
          yield td if block_given?
          td.create_table
        end
      end
    end
  end
end
