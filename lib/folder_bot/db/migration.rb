require 'sqlite3'
class Migration
  def initialize
    @adapter = SQLite3::Database.new 'bot.db'
  end
end
