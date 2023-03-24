class QuestionsController < ApplicationController
  def index 
    @questions = Question.all
  end
end

def new
  @question = Question.new 
end

#контроллер взаимодействует с файлом views/index.html передавая ему какую либо информацию или методы