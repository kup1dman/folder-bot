class Command
  include InlineHelper
  include ApiHelper
  include MediaHelper
  include MessageContext

  def initialize(bot, message)
    @bot = bot
    @message = message
  end
end
