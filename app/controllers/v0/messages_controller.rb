class V0::MessagesController < ApplicationController

  # POST /v0/messages
  # POST /v0/messages.json
  def create
    @message = current_app.messages.new(params[:message])

    if @message.save!
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end


end
