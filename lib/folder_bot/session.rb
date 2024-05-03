module FolderBot
  module Session
    def build_or_update_session(from:, chat:)
      session_value = "FolderBot:#{from.id}:#{chat.id}"
      return if FolderBot::REDIS.get('session_key') == session_value

      FolderBot::REDIS.set('session_key', session_value)
    end

    def session_key
      FolderBot::REDIS.get('session_key')
    end

    def save(key, value)
      if value.is_a?(Hash)
        FolderBot::REDIS.hset("#{session_key}:#{key}", value.to_a.flatten)
      else
        FolderBot::REDIS.set("#{session_key}:#{key}", value)
      end
    end

    def read(key)
      FolderBot::REDIS.hgetall("#{session_key}:#{key}").transform_keys(&:to_sym)
    rescue
      FolderBot::REDIS.get("#{session_key}:#{key}")
    end

    def clear(key)
      FolderBot::REDIS.set("#{session_key}:#{key}", '')
    end
  end
end
