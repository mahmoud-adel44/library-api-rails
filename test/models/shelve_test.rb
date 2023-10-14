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
require "test_helper"

class ShelveTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
