class ApplicationController < ActionController::Base # родительский класс для всех контроллеров Ruby on Rails

  include Pagy::Backend #улучшеная альтернатива kaminari, мы импортируем методы для бэка

  include ErrorHandling  #поодключаем модуль обработки ошибок

  include Authentication #подключаем модуль с аутентиикацией
end
