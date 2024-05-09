module FolderBot
  class Session
    def initialize(store:)
      @store = store
      @user_id = nil
    end

    def build_session(user_id:)
      @store.set("FolderBot:#{user_id}", user_id.to_s) unless @store.exists?("FolderBot:#{user_id}")
      @user_id = user_id
    end

    def []=(key, value)
      if value.is_a?(Hash)
        @store.hset("#{session_id}:#{key}", value.to_a.flatten)
      else
        @store.set("#{session_id}:#{key}", value)
      end
    end

    def [](key)
      @store.hgetall("#{session_id}:#{key}").transform_keys(&:to_sym)
    rescue
      @store.get("#{session_id}:#{key}")
    end

    def clear(key)
      @store.set("#{session_id}:#{key}", '')
    end

    private

    def session_id
      @store.get("FolderBot:#{@user_id}")
    end
  end
end
