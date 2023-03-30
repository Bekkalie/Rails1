# файл в директории для оюработки ошибок
module ErrorHandling
  extend ActiveSupport::Concern

  included do # included Это часть кода которая будет добавлена авттоматически при подключении модуля
      #тут мы обрабатываем ошибку в методе notfound в случае которой запращиваемая запись не найдена
    rescue_from ActiveRecord::RecordNotFound, with: :notfound 

    private

    def notfound#(exception) #метод notfound может принимать переменную exception(ошибку которая произошла)
    #logger.warn exception #можно использовать logger.warn чтобы записать в журнал событий ruby on rails 
    render file: 'public/404.html', status: :not_found, layout: false 
    #в качестве кода состояния мы говорим not_found, и никакого макета  
    end
  end
end