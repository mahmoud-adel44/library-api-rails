ActiveAdmin.register Borrow do
  includes(book: :translations)
  includes :user

  controller do
    def scoped_collection
      super.includes(book: :translations)
    end
  end

  filter :book, collection: -> { Book.includes(:translations).all.map { |b| [b.name, b.id] } }

  action_item :approve, only: :show do
    link_to "Apprrove", approve_admin_borrow_path(borrow), method: :put if borrow.pending?
  end

  member_action :approve, method: :put do
    borrow = Borrow.find(params[:id])
    borrow.approved!
    redirect_to admin_borrow_path(borrow)
  end

  action_item :reject, only: :show do
    link_to "Reject", reject_admin_borrow_path(borrow), method: :put if borrow.pending?
  end

  member_action :reject, method: :put do
    borrow = Borrow.find(params[:id])
    borrow.rejected!
    redirect_to admin_borrow_path(borrow)
  end

  index do
    selectable_column
    id_column
    column :user
    column :book
    column('status') do |b|
      status_tag b.status, class: STATUS_CLASSES[b.status] || 'status-rejected'
    end
    column('Returned') { |b| status_tag b.returned_at? }
    column('Returned At') { |b| b.returned_at_formated }
    actions
  end

  STATUS_CLASSES = {
    'pending' => 'status-pending',
    'approved' => 'status-approved',
    'rejected' => 'status-rejected'
  }.freeze

end
