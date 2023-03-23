Rails.application.routes.draw do
  get '/questions', to: 'questions#index' #localhost/questions HTTP GET
  #когда в одресной строке будет запрос questions то отправлять на questions#index

  root 'pages#index'
end
