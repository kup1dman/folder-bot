module Parser
  AVAILABLE_TEXT_COMMANDS = %w[/start /done].freeze

  def command(data, type)
    Object.const_get parsed_message(data, type).split('_').map(&:capitalize).join
  rescue
    nil
  end

  private

  def parsed_message(data, type)
    return nil if type == :message && AVAILABLE_TEXT_COMMANDS.none?(data)
    return nil unless data.start_with?('/')
    return 'pick_group' if data.match?(%r{^/pick_\w+$})

    data.sub('/', '')
  end
end
