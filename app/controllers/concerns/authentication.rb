module Authentication
  extend ActiveSupport::Concern

  included do 
    private

    def current_user #метод который проверяет сессию то есть вошел ли ползователь в сесси или нет 
      @current_user ||= User.find_by(id: session[:user_id]).decorate if session[:user_id].present? 
      #будет проверять id пользователи еслт оно есть + декорировать
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
      session.delete :user_id
    end
  
    helper_method :current_user, :user_signed_in? #helper_method позволяет преврятить указанает методы в хелперы 
  end
end