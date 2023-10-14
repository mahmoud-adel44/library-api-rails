# == Schema Information
#
# Table name: books
#
#  id          :bigint           not null, primary key
#  name        :string
#  author_id   :bigint           not null
#  shelve_id   :bigint           not null
#  borrowed_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Book < ApplicationRecord
  extend Mobility

  paginates_per 10
  translates :name, type: :string, association_name: :translations, ransack: true

  # Validations
  validate do |book|
    ShelveBookValidator.new(book).validate
  end

  validate do |book|
    CategoryBookValidator.new(book).validate
  end

  validates :author, presence: true
  validates :shelve, presence: true
  validates :name, presence: true

  # Relations
  belongs_to :author
  belongs_to :shelve

  has_many :book_categories
  has_many :categories, :through => :book_categories
  has_many :borrows
  has_many :reviews

  has_one :rating_avg, -> { with_rating_avg }, class_name: 'Book', foreign_key: :id

  # Scopes
  default_scope { order(id: :asc) }

  scope :filter_by_name, -> (name) { ransack(name_cont: name).result if name.present? }
  scope :filter_by_category, -> (categories) { joins(:categories).where(categories: { id: JSON.parse(categories) }) if categories.present? }
  scope :order_by_rating, -> (rate) {
    left_outer_joins(:reviews)
      .group(:id)
      .reorder(
        Arel.sql("AVG(reviews.rating) #{rate.upcase} NULLS LAST")
      ) if rate.present?
  }
  scope :with_rating_avg, -> {
    left_outer_joins(:reviews)
      .group(:id)
      .select("books.*, AVG(COALESCE(reviews.rating, 0)) AS average_rating")
  }

  def is_available
    self.borrowed_at.nil?
  end

  def created_at_formated
    self.created_at.strftime("%B %d, %Y")
  end

  def mark_as_returned(user)
    self.borrows.where(user: user).first!.update!(returned_at: Time.current)
  end
end
