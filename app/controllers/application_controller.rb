class ApplicationController < ActionController::Base # родительский класс для всех контроллеров Ruby on Rails

  include Pagy::Backend #улучшеная альтернатива kaminari, мы импортируем методы для бэка

  include ErrorHandling  #поодключаем модуль обработки ошибок

  private

  def current_user #метод который проверяет сессию то есть вошел ли ползователь в сесси или нет 
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id].present? 
    #будет проверять id пользователи еслт оно есть 
  end

  def user_signed_in?
    current_user.present? #будет возвращать булевое выражение если пользователь зашел
  end

  helper_method :current_user, :user_signed_in? #helper_method позволяет преврятить указанает методы в хелперы 
end
