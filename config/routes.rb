Rails.application.routes.draw do
  get '/questions', to: 'questions#index' #localhost/questions HTTP GET
  

  get '/questions/new', to: 'questions#new' 

  root 'pages#index'
end

#когда в адресной строке будет запрос questions то отправлять на questions#index
# на контроллер question и метод index который связан с файлом views/index.html