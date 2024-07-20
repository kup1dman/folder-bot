module FolderBot
  module Db
    module Dsl
      class SchemaStatements
        def create_table(name)
          td = SchemaDefinition.new(name)
          yield td if block_given?
          td.create_table
        end
      end
    end
  end
end
