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
  
    helper_method :current_user, :user_signed_in? #helper_method позволяет преврятить указанает методы в хелперы 
  end
end