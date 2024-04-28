module Session
  def build_session(from:, chat:)
    return if App::REDIS.get('session_key') == "FolderBot:#{from.id}:#{chat.id}"

    App::REDIS.set('session_key', "FolderBot:#{from.id}:#{chat.id}")
  end

  def save(key, value)
    if value.is_a?(Hash)
      App::REDIS.hset("#{session_key}:#{key}", value.to_a.flatten)
    else
      App::REDIS.set("#{session_key}:#{key}", value)
    end
  end

  def read(key)
    App::REDIS.hgetall("#{session_key}:#{key}").transform_keys(&:to_sym)
    rescue
      App::REDIS.get("#{session_key}:#{key}")
  end

  def session_key
    App::REDIS.get('session_key')
  end
end
