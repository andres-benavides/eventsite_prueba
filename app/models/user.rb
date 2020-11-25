class User < ApplicationRecord
  has_many :url

  before_save :generate_auth_token

  def generate_auth_token
    unless auth_token.present?
      self.auth_token = SecureRandom.hex
    end
  end
end
