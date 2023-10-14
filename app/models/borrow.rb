# == Schema Information
#
# Table name: borrows
#
#  id          :bigint           not null, primary key
#  user_id     :bigint           not null
#  book_id     :bigint           not null
#  borrowed_at :datetime         not null
#  return_time :datetime         not null
#  returned_at :datetime
#  status      :integer          default("pending")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Borrow < ApplicationRecord
  include ActiveModel::Dirty

  after_create :notify_admin
  after_update :notify_user

  enum :status, {
    pending: BorrowStatus::PENDING,
    approved: BorrowStatus::APPROVED,
    rejected: BorrowStatus::REJECTED,
  }

  # Validations
  validates :user, presence: true
  validates :book, presence: true
  validates :borrowed_at, presence: true, comparison: { greater_than_or_equal_to: Time.current }, if: :borrowed_at_will_be_changed?
  validates :return_time, comparison: { greater_than: :borrowed_at }, presence: true
  validate :book_must_be_available, on: :create
  # validates :returned_at, comparison: { greater_than: :borrowed_at }, presence: false
  # validates :status, inclusion: { in: status.values }

  # Relations
  belongs_to :user
  belongs_to :book
  has_many :borrows

  def borrowed_at_will_be_changed?
    self.borrowed_at_changed?
  end

  def book_must_be_available
    if Borrow.where(returned_at: nil, book_id: book.id).where.not(status: BorrowStatus::REJECTED).any?
      errors.add(:book, "is Available try again later")
    end
  end

  def notify_admin
    BorrowBookOrderNotification.with(book: self.book).deliver(AdminUser.first)
  end
  def notify_user
    BorrowBookStatusUpdatedNotification.with(borrow: self).deliver(self.user)
  end

  def returned_at_formated
    self.returned_at&.strftime("%B %d, %Y")
  end
end
