# @topic Messages
# @url Message
class V0::MessagesController < ApplicationController

  ##
  # Creates message that will be propagated within 10 minutes to all apps registered
  # to this key_name
  #
  # @url [POST] /v0/messages
  # @argument app_key [String] your apps app_key, given to you by sys-admin.
  # @argument message [Hash] attributes of your message.
  #
  # @key_for message [String] key_name message will be propagated to apps registered to this key_name
  # @key_for message [String] data this will be forwarded to all apps.
  #
  # @example_response [201] 'message posted'
  # @example_response [422] {errors: {...} }
  def create
    @message = current_app.messages.new(params[:message])

    if @message.save
      render json: 'message posted', status: :created
    else
      render json: {errors: @message.errors}, status: :unprocessable_entity
    end
  end


end
