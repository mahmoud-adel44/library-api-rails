class Api::NotificationController < ApiApplicationController
  def index
    @current_user.notifications.read

    response_success(
      data: NotificationSerializer.new(@current_user.notifications).serializable_hash
    )
  end
end
