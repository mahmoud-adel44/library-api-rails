# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  name              :string           not null
#  email             :string           not null
#  password_digest   :string           not null
#  email_verified_at :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :email
end
