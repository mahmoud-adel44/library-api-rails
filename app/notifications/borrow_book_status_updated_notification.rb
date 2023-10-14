class BorrowBookStatusUpdatedNotification < Noticed::Base

  deliver_by :database

  param :borrow

  def message
    "Your order for borrow (#{params[:borrow].book.name}) has been [#{params[:borrow].status}]"
  end

  def url
    book_path(params[:borrow].book)
  end
end
