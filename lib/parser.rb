class Parser
  def initialize(message, type)
    @message = message
    @message_type = type
  end

  def command
    case @message_type
    when :message, :callback
      Object.const_get parsed_message.split('_').map(&:capitalize).join
    when :reply
      Object.const_get App::REDIS.get('context').split('_').map(&:capitalize).join
    end
  end

  private

  def parsed_message
    return nil unless can_parse?

    case @message_type
    when :message
      @message.text[1..]
    when :callback
      @message.data.match?(%r{^/pick_\w+$}) ? 'pick_group' : @message.data[1..]
    end
  end

  def can_parse?
    case @message_type
    when :message
      !@message.text.empty? && @message.text.start_with?('/')
    when :callback
      !@message.data.empty? && @message.data.start_with?('/')
    else
      false
    end
  end
end
