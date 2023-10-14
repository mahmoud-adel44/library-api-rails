# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  rating     :integer
#  comment    :text
#  book_id    :bigint           not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Review < ApplicationRecord
  # Relations
  belongs_to :book
  belongs_to :user

  # Validations
  validates :book, presence: true, uniqueness: { scope: :user, message: "has already been reviewed by this user" }
  validates :user, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true, length: { maximum: 500 }

end
