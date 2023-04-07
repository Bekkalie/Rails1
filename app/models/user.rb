class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true #проверка на уровне кода
  validates :name, presence: true
end
