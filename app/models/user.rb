class User < ApplicationRecord
  attr_accessor :old_password # атрибут для появления нового поля в форме

  has_secure_password validations: false #отключим проверки и пропишем вручнуюю?

  #проверка на уровне кода

  validate :correct_old_password, on: :update,if -> { password.present? } #лямбда))))
  #проверяем старый пароль, только при обновлении записи и если новый пароль был указан

  validate :password_presence # чтобы убрать allow_blank при регистрации
  validates :password, confirmation: true, allow_blank: true, length: {minimum: 8, maximum: 70}
  #confirmation Это параметр который проверяет 
  #совпадает ли введенный текст с с указаным полем в бд, в нашем случае поле password,
  #allow_blank Это проверка которая допукает то что пользователь может не менять пароль

  #validates :name, presence: true
  validates :email, presence: true, uniqueness: true, 'valid_email_2/email': true 
  #проверяем коррекстность введеного имейла через gem valid_aemail2

  validate :password_complexity

  private

  def password_complexity #решение из device, которое проверяет надежность пароля
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/

    errors.add :password, 'complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end

  def password_presence # чтобы убрать allow_blank при регистрации
    errors.add(:password, :blank) unless password_digest.present? 
    #добавить сообщения об ошибке связаных с паролем что он пустой(blank) но не в том случае если password_digest был уже указан
    #password_digest.present? Значит что пользователь указал уже какой то пароль раньше
  end

  def correct_old_password
    return if BCrypt::Password.new(password_digest_was).is_password?(old_password) #если старый пароль был введен верно то просто выходим 

    errors.add :old_password, 'is incorrect'
  end
end