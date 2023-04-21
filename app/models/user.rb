# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :old_password, :remember_token # атрибуты для появления нового поля в форме

  has_secure_password validations: false # отключим проверки и пропишем вручнуюю?

  # проверка на уровне кода

  validate :correct_old_password, on: :update, if: -> { password.present? } # лямбда))))
  # проверяем старый пароль, только при обновлении записи и если новый пароль был указан

  validate :password_presence # чтобы убрать allow_blank при регистрации
  validates :password, confirmation: true, allow_blank: true, length: { minimum: 8, maximum: 70 }
  # confirmation Это параметр который проверяет
  # совпадает ли введенный текст с с указаным полем в бд, в нашем случае поле password,
  # allow_blank Это проверка которая допукает то что пользователь может не менять пароль

  # validates :name, presence: true
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true
  # проверяем коррекстность введеного имейла через gem valid_aemail2

  validate :password_complexity

  def remember_me
    self.remember_token = SecureRandom.urlsafe_base64
    # SecureRandom.urlsafe_base64 модуль и метод которые сгинерируют рандомное значение

    # rubocop:disable Rails/SkipsModelValidations
    # строка выше отключает проверку Rubocop по определенной ошибке(в нашем случае этой ошибке Rails/SkipsModelValidations)

    update_column :remember_token_digest, digest(remember_token)
    # обновляем колонку в бд(метод update_column) под названием remember_token_digest и вставляем в нее значение remember_token
    # при использовании update_column пропускаются валидации(проверки)

    # rubocop:enable Rails/SkipsModelValidations
    # а эта строка включает обратно проверку по отключенной ошибке
  end

  # метод для выхода того чтобы убрать запоминание(забыть пользователя в системе) через бд
  def forget_me
    # rubocop:disable Rails/SkipsModelValidations
    # строка выше отключает проверку Rubocop по определенной ошибке(в нашем случае этой ошибке Rails/SkipsModelValidations)

    update_column :remember_token_digest, nil
    # обновляем колонку в бд(метод update_column) под названием remember_token_digest и значение remember_token опустошаем

    # rubocop:enable Rails/SkipsModelValidations
    # а эта строка включает обратно проверку по отключенной ошибке
    self.remember_token = nil # делаем значение токена пустым
  end

  def remember_token_authenticated?(remember_token)
    return false unless remember_token_digest.present?

    BCrypt::Password.new(remember_token_digest).is_password?(remember_token)
    # проверяем тот хэш который есть нас и который введен в строку
  end

  private

  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  # решение из device, которое проверяет надежность пароля
  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    msg = 'complexity requirement not met. Length should be 8-70 characters and ' +
          'include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
    errors.add :password, msg
  end

  # чтобы убрать allow_blank при регистрации
  def password_presence
    errors.add(:password, :blank) unless password_digest.present?
    # добавить сообщения об ошибке связаных с паролем что он пустой(blank) но не в том случае если password_digest был уже указан
    # password_digest.present? Значит что пользователь указал уже какой то пароль раньше
  end

  def correct_old_password
    # если старый пароль был введен верно то просто выходим
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password)

    errors.add :old_password, 'is incorrect'
  end
end
