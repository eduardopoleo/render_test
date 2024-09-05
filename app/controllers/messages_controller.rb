class MessagesController < ApplicationController
    def index
      @messages = Message.all
      @message = Message.new
    end
  
    def create
      @message = Message.new(message_params)
      if @message.save
        # Broadcast the message using Turbo Streams
        broadcast_message(@message)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to messages_path }
        end
      else
        render :index
      end
    end
  
    private
  
    def message_params
      params.require(:message).permit(:content, :user)
    end

    def broadcast_message(message)
      Turbo::StreamsChannel.broadcast_prepend_to "messages", target: "messages", partial: "messages/message", locals: { message: message }
    end
  end
  