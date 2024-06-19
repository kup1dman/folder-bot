module FolderBot
  class Session
    attr_reader :current_user

    def initialize
      @redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))
      @current_user = nil
    end

    def build_session(tg_uid:)
      return if @current_user&.tg_uid == tg_uid

      @current_user = Models::User.find_by(:tg_uid, tg_uid) || Models::User.create(tg_uid: tg_uid)
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
      "FolderBot:#{@current_user.tg_uid}"
    end
  end
end
