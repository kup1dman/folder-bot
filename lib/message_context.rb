module MessageContext
  include Session
  def save_context(context)
    write('context', context)
  end

  def context
    read('context')
  end

  def save_message(**message)
    write('message', message)
  end

  def message
    read('message')
  end

  def save_group(group)
    write('group', group)
  end

  def group
    read('group')
  end
end
