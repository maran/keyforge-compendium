class MessagesController < ApplicationController
  def create
    @conversation = Conversation.with_user(current_user.id).find(params[:conversation_id])
    message = @conversation.messages.build(user: current_user, body: params[:message][:body])
    if message.save
      user_id = @conversation.user.id

      if @conversation.user == current_user
        user_id = @conversation.receiving_user.id
      end
      mail = ApplicationMailer.new_reply(message.id, user_id)
      mail.deliver_later
      redirect_to conversation_path(@conversation), notice: "Message sent"
    end
  end
end
