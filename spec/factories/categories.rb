# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :category do
    name_en { Faker::Book.genre }
    # name_ar { Faker::Book.genre }
    name_ar { Faker::Base.with_locale(:ar) { Faker::Book.genre } }
  end
end
