class ApplicationController < ActionController::API

  def current_app
    @current_app ||= App.find_by_app_key(params[:app_key])
  end

  before_filter :require_app_key

  def require_app_key
    if current_app.nil?
      render text: 'FORBIDDEN', status: 403
    end
  end
end
