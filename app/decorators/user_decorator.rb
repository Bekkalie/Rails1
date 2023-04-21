# frozen_string_literal: true

# это декоратор
class UserDecorator < Draper::Decorator
  delegate_all

  # проверка есть ли имя, если имя будет ввелено прирегестрации в углу будет отбражаться имя
  def name_or_email
    # если нет то будет отображаться название почты до знака @
    return name if name.present?

    email.split('@')[0]
  end
end
