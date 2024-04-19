module MessageContext
  def save_context(context)
    App::REDIS.set('context', context)
  end
end
