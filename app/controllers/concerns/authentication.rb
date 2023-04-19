module Authentication
  extend ActiveSupport::Concern

  included do 
    private

    def current_user #метод который проверяет сессию то есть вошел ли ползователь в сесси или нет

      if session[:user_id].present? #если в сесси ничего нет то идем дальше

        @current_user ||= User.find_by(id: session[:user_id]).decorate 
        #будет проверять id пользователи если оно есть + декорировать

      elsif cookies.encrypted[:user_id].present? #и смотрим, а не запоминали мы его раньше?
        user = User.find_by(id: cookies.encrypted[:user_id]) #ищем куки с шифром этого пользователя
        if user&.remember_token_authenticated?(cookies.encrypted[:remember_token]) 
          #если токен соответствует с каким-нибудь токеном который есть в бд, 
          #то входим в аккаунт и еще добавляем пользователя в сессию 
          sign_in user
          @current_user ||= user.decorate
        end
      end
    end
  
    def user_signed_in?
      current_user.present? #будет возвращать булевое выражение если пользователь зашел
    end

    def require_authentication
      return unless !user_signed_in?

      flash[:warning] = "You are not signed in!"
      redirect_to root_path 
    end

    def require_no_authentication
      return unless user_signed_in?

      flash[:warning] = "You are already signed in!"
      redirect_to root_path
    end

    def sign_in(user)
      session[:user_id] = user.id #строчка кода для того чтобы сохранять пользователя во время сессии
    end

    def sign_out
      forget current_user
      session.delete :user_id
      @current_user = nil
    end

    def remember(user) #метод который позволяет запоминать пользователя
      user.remember_me
      cookies.encrypted.permanent[:remember_token] = user.remember_token # с помощью куки файлов))))))
      # но к у куки файлов есть свойство истекать и через этот период они становяться не действительными 
      # метод permanent поставит на очень болшую дату, но можно поставить и свою дату
      # метод encrypted зашифровывает куки файлы
      cookies.encrypted.permanent[:user_id] = user.id #куки который обозначает кого мы запомнили
    end

    def forget(user)
      user.forget_me #"забываем" пользователя через бд
      cookies.delete :user_id #удаляем куки файлыы
      cookies.delete :remember_me
    end
  
    helper_method :current_user, :user_signed_in? #helper_method позволяет преврятить указанает методы в хелперы 
  end
end