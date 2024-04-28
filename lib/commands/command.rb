class Command
  include Session
  include InlineHelper
  include ApiHelper
  include MediaHelper

  def initialize(bot, message)
    @bot = bot
    @message = message
  end
end
