module FolderBot
  module Parser
    def command(data, type)
      Object.const_get prefix(type) + parsed_message(data)
    rescue
      nil
    end

    private

    def parsed_message(data)
      return nil unless data.start_with?('/')
      return 'PickGroup' if data.match?(%r{^/pick_\w+$})

      data.sub('/', '').split('_').map(&:capitalize).join
    end

    def prefix(type)
      "FolderBot::Commands::#{type.to_s.capitalize}::"
    end
  end
end
