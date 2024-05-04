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

      data = '/pick_group' if data.match?(%r{^/pick_([a-zA-Z]|[а-яА-Я])+$})

      "FolderBot::Commands::#{type.to_s.capitalize}::" + data.sub('/', '').split('_').map(&:capitalize).join
    end
  end
end
