class CreateGroupReply < Command
  def call
    group_name = @message.text
    STORAGE.write_to_groups_table(group_name)
    REDIS.hset('current-group', 'id', STORAGE.get_group_id_by_name(group_name))
    send_message(@bot, @message, 'Группа создана!')
    PickGroup.new(@bot, @message).group_info(@bot, @message, group_name) # плохо
  end
end
