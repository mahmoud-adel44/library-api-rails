# To deliver this notification:
#
# BorrowBookOrderNotification.with(post: @post).deliver_later(current_user)
# BorrowBookOrderNotification.with(post: @post).deliver(current_user)

class BorrowBookOrderNotification < Noticed::Base

  deliver_by :database

  param :book

  def to_database
    {
      type: self.class.name,
      params: params
    }
  end

  # Define helper methods to make rendering easier.
  #
  def message
    "new book borrow has been ordered"
  end

  def url
    url_for(params[:book])
  end
end
