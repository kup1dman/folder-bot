module Session
  def build_session(from:, chat:)
    App::REDIS.set('session_key', "FolderBot:#{from.id}:#{chat.id}")
  end

  def write(key, value)
    if value.is_a?(Hash)
      App::REDIS.hset("#{session_key}:#{key}", value.to_a.flatten)
    else
      App::REDIS.set("#{session_key}:#{key}", value)
    end
  end

  def read(key, value = nil)
    if value
      App::REDIS.hget("#{session_key}:#{key}", value)
    else
      App::REDIS.get("#{session_key}:#{key}")
    end
  end

  def session_key
    App::REDIS.get('session_key')
  end
end
