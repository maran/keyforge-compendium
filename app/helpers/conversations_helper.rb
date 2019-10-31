module ConversationsHelper
  def align_class(message)
    if message.user == current_user
      return "float-left"
    else
      return "float-right"
    end
  end
end
