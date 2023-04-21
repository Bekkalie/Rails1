# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  # rubocop:disable Metrics/BlockLength
  # строка выше отключает проверку Rubocop по определенной ошибке(в нашем случае этой ошибке Metrics/BlockLength)
  # Metrics/BlockLength - слишком длинный блок, но в этом случае идет перечисление методов
  included do
    private

    # метод который проверяет сессию то есть вошел ли ползователь в сесси или нет
    def current_user
      user = session[:user_id].present? ? user_from_session : user_from_token 
      # если в сесси что то есть то пытаемся найти пользователя
        
      @current_user ||= user&.decorate # и смотрим, а не запоминали мы его раньше?
      #& нужен для случая если пользователь в систему не вошел, а decorate нельзя вызвать на nil
      #и амперсант предупреждает что может быть nil тогда он не вызовет метод
    end

    def user_from_token
      token = cookies.encrypted[:user_id]
      user = User.find_by(id: token) # ищем куки с шифром этого пользователя
      return unless user&.remember_token_authenticated?(token)
        # если токен соответствует с каким-нибудь токеном который есть в бд,
        # то входим в аккаунт и еще добавляем пользователя в сессию
        sign_in user
        user
      end
    end

    def user_from_session
      @current_user ||= User.find_by(id: session[:user_id])
      # будет проверять id пользователи если оно есть + декорировать
    end

    def user_signed_in?
      current_user.present? # будет возвращать булевое выражение если пользователь зашел
    end

    def require_authentication
      return if user_signed_in?

      flash[:warning] = 'You are not signed in!'
      redirect_to root_path
    end

    def require_no_authentication
      return unless user_signed_in?

      flash[:warning] = 'You are already signed in!'
      redirect_to root_path
    end

    def sign_in(user)
      session[:user_id] = user.id # строчка кода для того чтобы сохранять пользователя во время сессии
    end

    def sign_out
      forget current_user
      session.delete :user_id
      @current_user = nil
    end

    # метод который позволяет запоминать пользователя
    def remember(user)
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token # с помощью куки файлов))))))
      # но к у куки файлов есть свойство истекать и через этот период они становяться не действительными
      # метод permanent поставит на очень болшую дату, но можно поставить и свою дату
      # метод encrypted зашифровывает куки файлы
      cookies.encrypted.permanent[:user_id] = user.id # куки который обозначает кого мы запомнили
    end

    def forget(user)
      user.forget_me # "забываем" пользователя через бд
      cookies.delete :user_id # удаляем куки файлыы
      cookies.delete :remember_me
    end

    helper_method :current_user, :user_signed_in? # helper_method позволяет преврятить указанает методы в хелперы
  end
  # rubocop:enable Metrics/BlockLength
    # а эта строка включает обратно проверку по отключенной ошибке
end
