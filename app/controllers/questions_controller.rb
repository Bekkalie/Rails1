class QuestionsController < ApplicationController

  #контроллер взаимодействует с файлом views/index.html передавая ему какую либо информацию или методы

  def index 
    @questions = Question.all
  end

  def edit 
    @question = Question.find_by id: params[:id]
  end

  def update 
    @question = Question.find_by id: params[:id]
    if @question.update question_params
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy 
    @question = Question.find_by id: params[:id]
    @question.destroy
    redirect_to questions_path
  end

  def new
    @question = Question.new 
  end

  #в случаях выше программа найдет просто файл с таким же названием и выведет его на экран 
  # а в случае create просто выведет на экран данные
  def create 
    # render plain: params
    @question = Question.new question_params
    if @question.save 
      redirect_to questions_path
    else
      render :new
    end
  end

  private 

  def question_params 
    params.require(:question).permit(:title, :body) #достать из формы значения с ключом title и body
  end
end