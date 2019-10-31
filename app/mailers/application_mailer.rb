class ApplicationMailer < ActionMailer::Base
  default from: 'robot@keyforge-compendium.com'
  layout 'mailer'

  def new_reply(message_id, user_id)
    @message = Message.find(message_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "[Keyforge Compendium] Reply received")
  end

  def new_conversation(convo_id)
    @conversation = Conversation.find(convo_id)
    @deck = @conversation.deck
    mail(to: @conversation.receiving_user.email, subject: "[Keyforge Compendium] New conversation")
  end
end
