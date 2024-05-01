module Session
  def build_or_update_session(from:, chat:)
    session_value = "FolderBot:#{from.id}:#{chat.id}"
    return if App::REDIS.get('session_key') == session_value

    App::REDIS.set('session_key', session_value)
  end

  def session_key
    App::REDIS.get('session_key')
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
end
