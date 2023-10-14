# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  extend Mobility
  translates :name, type: :string, association_name: :translations

  paginates_per 10

  has_many :book_categories
  has_many :books, :through => :book_categories

  validates :name, presence: true
end
