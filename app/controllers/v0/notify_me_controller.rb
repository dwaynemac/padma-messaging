# @topic Notifications
# @url Subscriptions
class V0::NotifyMeController < ApplicationController

  ##
  # Lists keys to wich you are listed
  #
  # @url [GET] /v0/notify_me
  #
  # @argument app_key [String]
  #
  # @response_field collection [Array] list of message keys to wich you're subscribed
  # @response_field total [Integer] number of message keys you're subscribed to
  #
  # @example_response [200] {collection, total }
  def index
    @notify_mes = current_app.notify_mes
    render json: {collection: @notify_mes, total: @notify_mes.count}, status: 200
  end

  ##
  # Subscribe to notifications from key_name
  #
  # @url [POST] /v0/notify_me
  #
  # @argument app_key [String]
  # @argument notify_me [Hash]
  #
  # @key_for notify_me [String] secret_key POST to URL will send this secret_key: for security.
  # @key_for notify_me [String] url It must be an https valid URL
  # @key_for notify_me [String] key_name Key to wich you subscribe. eg: 'enrollment'
  #
  # @example_response [201] 'OK'
  def create
    @notify_me = current_app.notify_mes.new(params[:notify_me])
    if @notify_me.save
      render json: 'ok', status: 201
    else
      render json: {errors: @notify_me.errors }, status: 422
    end
  end

  ##
  # Unsubscribe from notifications
  #
  # @url [DELETE] /v0/notify_me
  #
  # @argument app_key [String]
  # @argument key_name [String]
  #
  # @example_response [200] 'OK'
  def destroy
    message_key = MessageKey.find_by_name(params[:key_name])
    if message_key
      current_app.notify_mes.where(message_key_id: message_key.id).destroy_all
    else
      render json: 'youre not subscribed to this key_name', status: 404
    end
  end
end
