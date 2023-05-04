# frozen_string_literal: true

# родительский класс для всех контроллеров Ruby on Rails
class ApplicationController < ActionController::Base
  # before_action :set_decorated_current_user

  include Pagy::Backend # улучшеная альтернатива kaminari, мы импортируем методы для бэка

  include ErrorHandling  # поодключаем модуль обработки ошибок

  include Authentication # подключаем модуль с аутентиикацией

  private

  # def set_decorated_current_user
  #   @current_user = current_user.decorate
  # end
end
