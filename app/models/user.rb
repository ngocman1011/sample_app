class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true,
    length: {maximum: Settings.validation.name_max}
  validates :email, presence: true,
    length: {maximum: Settings.validation.email_max},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, length: {minimum: Settings.validation.pass_min}
  has_secure_password

  before_save :downcase_email
  private
  def downcase_email
    email.downcase!
  end
end
