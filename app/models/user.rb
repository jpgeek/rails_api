# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  validates_presence_of :first_name, :last_name, :email

  def admin?
    role == "admin"
  end

  def user?
    role == "user"
  end
end
