class State
  attr_reader(:current_group, :current_message, :current_process)

  def initialize
    @current_message = nil
    @current_group = nil
    @current_process = nil
  end

  def set_current_message(message)
    @current_message = message
  end

  def set_current_group(group)
    @current_group = group
  end

  def set_current_process(process)
    @current_process = process
  end
end