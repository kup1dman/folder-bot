module FolderBot
  module Parser
    AVAILABLE_TEXT_COMMANDS = %w[/start /done].freeze

    def command(data, type)
      Object.const_get parsed_message(data, type)
    rescue
      nil
    end

    private

    def parsed_message(data, type)
      return nil unless data.start_with?('/')
      return nil if type == :messages && !AVAILABLE_TEXT_COMMANDS.include?(data)

      data = '/pick_group' if data.match?(%r{^/pick_\w+$})

      "FolderBot::Commands::#{type.to_s.capitalize}::" + data.sub('/', '').split('_').map(&:capitalize).join
    end
  end
end
