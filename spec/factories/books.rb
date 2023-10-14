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
FactoryBot.define do
  factory :book do
    name_en { Faker::Book.title }
    # name_ar { Faker::Name.with_locale(:ar) { Faker::Name.name_with_middle } }
    name_ar { Faker::Base.with_locale(:ar) { Faker::Book.title } }
    association :author, factory: :author
    association :shelve, factory: :shelve
  end
end
