# == Schema Information
#
# Table name: shelves
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  max_amount :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :shelve do
    name { Faker::Name.name }
    max_amount { Faker::Number.between(from: 3 , to: 20).to_i }
  end
end
