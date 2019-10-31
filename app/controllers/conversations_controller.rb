class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @conversation = Conversation.with_user(current_user.id).find(params[:id])
  end

  def new
    @deck = Deck.find(params[:deck_id])
    if @deck.present? && @deck.for_sale?
      @conversation = current_user.conversations.build(deck: @deck)
      @conversation.messages.build
    else
      redirect_to root_path, notice: "Deck not found or not for sale."
    end
  end

  def create
    @deck = Deck.find(params[:conversation][:deck_id])
    conversations = 0
    if @deck.present? && @deck.for_sale?
      @deck.decks_users.for_sale.each do |du|
        convo = current_user.conversations.build(convo_params.merge!(receiving_user_id: du.user_id))
        if convo.save
          conversations += 1
          mail = ApplicationMailer.new_conversation(convo.id)
          mail.deliver_later
        end
      end
    end
    if conversations > 0
      redirect_to deck_path(@deck.uuid), notice: "Message has been sent to users who claim to be owning this deck."
    else
      render :new
    end
  end

  def convo_params
    new_params = params.require(:conversation).permit(:deck_id, :subject, messages_attributes: [:body])
    new_params[:messages_attributes]["0"].merge!(user_id: current_user.id)
    return new_params
  end
end
