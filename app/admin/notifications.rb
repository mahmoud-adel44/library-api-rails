ActiveAdmin.register Notification do
  after_action :mark_notification_as_read, only: :show
  scope_to -> { current_admin_user }

  controller do
    def mark_notification_as_read
      current_admin_user.notifications.where(id: params[:id]).mark_as_read!
    end

    def current_admin
      current_admin_user
    end
  end

  index do
    selectable_column
    id_column
    column :read_at
    column('message') { |n| n.to_notification.message }
    column('sent at') { |n| n.created_at }
    column('seen') { |n| status_tag n.read? }
    column 'book url' do |notification|
      link_to notification.params[:book].name, admin_book_path(notification.params[:book])
    end
    actions
  end
  
end
