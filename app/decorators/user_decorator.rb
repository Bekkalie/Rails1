class UserDecorator < Draper::Decorator #это декоратор
  delegate_all

  def name_or_email # проверка есть ли имя, если имя будет ввелено прирегестрации в углу будет отбражаться имя 
                    #если нет то будет отображаться название почты до знака @
    return name if name.present?

    email.split('@')[0]
  end
end
