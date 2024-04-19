class Parser
  def initialize(message, type: nil)
    @message = message
    @message_type = type
  end

  def command
    case @message_type
    when :message
      Client::MESSAGES.keys.find { |key| key == parsed_message&.to_sym }
    when :callback
      Client::CALLBACKS.keys.find { |key| key == parsed_message&.to_sym }
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
    when :reply
      @message.reply_to_message.text
    end
  end

  def can_parse?
    case @message_type
    when :message
      !@message.text.empty? && @message.text.start_with?('/')
    when :callback
      !@message.data.empty? && @message.data.start_with?('/')
    when :reply
      !@message.reply_to_message.text.empty?
    end
  end
end
