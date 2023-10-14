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
FactoryBot.define do
  factory :book_category, class: 'BookCategory' do
    association :book, factory: :book
    association :category, factory: :category
  end
end
