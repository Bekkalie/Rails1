Rails.application.routes.draw do
  resources :questions, only: %i[index new edit create update destroy]
  # get '/questions', to: 'questions#index' #localhost/questions HTTP GET
  

  # get '/questions/new', to: 'questions#new' # get значит будет брать

  # get '/questions/:id/edit', to: 'questions#edit'

  # post '/questions', to: 'questions#create' # post значит будет отправлять 

  root 'pages#index'
end

#когда в адресной строке будет запрос questions то отправлять на questions#index
# на контроллер question и метод index который связан с файлом views/index.html