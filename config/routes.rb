Rails.application.routes.draw do

  #стандартные методы их запись можно сократить таким способом 
  #resources :questions, only: %i[index new edit create update destroy show] #каждый из этих методов можно писать отдельно
  #если нужно все 7 стандартных методов то можно записать просто
  #resources :questions 

  resources :users, only: %i[new create]  
  
  resources :questions do 
    resources :answers, except: %i[new show] #вложенный маршрут, except(кроме)
  end
  
  
  
  # get '/questions', to: 'questions#index' #localhost/questions HTTP GET
  

  # get '/questions/new', to: 'questions#new' # get значит будет брать

  # get '/questions/:id/edit', to: 'questions#edit'

  # post '/questions', to: 'questions#create' # post значит будет отправлять 

  root 'pages#index'

  #когда в адресной строке будет запрос questions то отправлять на questions#index
# на контроллер question и метод index который связан с файлом views/index.html

end