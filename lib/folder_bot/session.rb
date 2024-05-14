module FolderBot
  class Session
    def initialize
      @redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))
      @user_id = nil
    end

    def build_session(user_id:)
      @redis.set("FolderBot:#{user_id}", user_id.to_s) unless @redis.exists?("FolderBot:#{user_id}")
      @user_id = user_id
    end

    def []=(key, value)
      if value.is_a?(Hash)
        @redis.hset("#{session_id}:#{key}", value.to_a.flatten)
      else
        @redis.set("#{session_id}:#{key}", value)
      end
    end

    def [](key)
      @redis.hgetall("#{session_id}:#{key}").transform_keys(&:to_sym)
    rescue
      @redis.get("#{session_id}:#{key}")
    end

    def clear(key)
      @redis.set("#{session_id}:#{key}", '')
    end

    private

    def session_id
      @redis.get("FolderBot:#{@user_id}")
    end
  end
end
