# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { minimum: 2 } # проверка(валидация) title на длину(мин 2) в субд
  validates :body, presence: true, length: { minimum: 2 } # проверка(валидация) body на длину(мин 2) в субд
end

# каждая модель хранит в себе данные и бизнес логику и  связана с одноименной базой данных и позволяет оттуда их достовать
