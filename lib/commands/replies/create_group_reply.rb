class CreateGroupReply < Command
  def call
    group_name = @message.text
    App::STORAGE.write_to_groups_table(group_name)
    save_group App::STORAGE.get_group_id_by_name(group_name)
    send_message(@bot, @message, 'Группа создана!')
    PickGroup.new(@bot, @message).group_info(@bot, @message, group_name) # плохо
  end
end
