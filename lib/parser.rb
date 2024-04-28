module Parser
  def command(data)
    Object.const_get parsed_message(data).split('_').map(&:capitalize).join
  rescue
    nil
  end

  private

  def parsed_message(data)
    return nil unless data.start_with?('/')
    return 'pick_group' if data.match?(%r{^/pick_\w+$})

    data.sub('/', '')
  end
end
