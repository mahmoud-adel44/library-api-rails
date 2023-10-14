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
class Shelve < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :books

  def created_at_formated
    self.created_at.strftime("%B %d, %Y")
  end
end
