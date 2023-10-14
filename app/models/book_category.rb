# == Schema Information
#
# Table name: book_categories
#
#  id          :bigint           not null, primary key
#  book_id     :bigint           not null
#  category_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class BookCategory < ApplicationRecord
  belongs_to :book
  belongs_to :category
end
