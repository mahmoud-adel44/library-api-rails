class Api::BorrowBookController < ApiApplicationController
  before_action :set_book, only: :return_book

  def store
    @current_user.borrows.create!(book_params)

    response_success
  end

  def return_book
    ActiveRecord::Base.transaction do
      @book.mark_as_returned(@current_user)
      @book.reviews.create!(review_params.merge(user: @current_user))
    end

    response_success
  end

  private

  def book_params
    params.require(:borrow).permit(:book_id, :borrowed_at, :return_time)
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  # @return[Book]
  def set_book
    @book = Book.find(params[:id])
  end
end
