class CheckOverBorrowReturnTimeJob < ApplicationJob
  queue_as :default

  def perform(*args)
    @borrows = Borrow.includes(:book, :user).where(status: BorrowStatus::APPROVED, returned_at: nil)
                     .select { |borrow| borrow.return_time.to_date == 1.day.from_now.to_date }

    @borrows.each do |borrow|
      UserDeadlineBorrowBookMailer.with(user: borrow.user,book: borrow.book).send_email.deliver_now
    end
  end
end
