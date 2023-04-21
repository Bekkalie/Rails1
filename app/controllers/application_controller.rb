# frozen_string_literal: true

# родительский класс для всех контроллеров Ruby on Rails
class ApplicationController < ActionController::Base
  include Pagy::Backend # улучшеная альтернатива kaminari, мы импортируем методы для бэка

  include ErrorHandling  # поодключаем модуль обработки ошибок

  include Authentication # подключаем модуль с аутентиикацией
end
