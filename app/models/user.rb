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
class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :password, confirmation: true, presence: true
  validates :password_confirmation, presence: true
  has_secure_password :password, validations: false

  # Relations
  has_many :borrows
  has_many :notifications, as: :recipient, dependent: :destroy

  def mark_as_verified
    update_column(:email_verified_at, Time.current) if self.email_verified_at.nil?
  end

  def is_unverifyed
    self.email_verified_at.nil?
  end
end
