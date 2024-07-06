module FolderBot
  module Parser
    def command(data, type)
      Object.const_get parsed_message(data, type)
    rescue
      nil
    end

    private

    def parsed_message(data, type)
      return nil unless data.start_with?('/')

      "FolderBot::Commands::#{type.to_s.capitalize}::" + data.scan(/\/([^?]+)/).flatten[0].split('_').map(&:capitalize).join
    end
  end
end
