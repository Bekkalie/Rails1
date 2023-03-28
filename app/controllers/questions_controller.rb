class QuestionsController < ApplicationController

  #контроллер взаимодействует с файлом views/index.html передавая ему какую либо информацию или методы

  def index 
    @questions = Question.all
  end


  def new
    @question = Question.new 
  end


  def edit 
    @question = Question.find_by id: params[:id]
  end


  #в случаях выше программа найдет просто файл с таким же названием и выведет его на экран 
  # а в случае create просто выведет на экран данные
  def create 
    # render plain: params
    @question = Question.new question_params
    if @question.save 
      flash[:success] = "Question created!" 
      #flash это сообщение которое появляется один раз, после перезагрузки пропадает, flash является хэшем ключ то что в скобках, а значение после равно
      redirect_to questions_path
    else
      render :new
    end
  end


  def update 
    @question = Question.find_by id: params[:id]
    if @question.update question_params
      flash[:success] = "Question updated!" 
      redirect_to questions_path
    else
      render :edit
    end
  end


  def destroy 
    @question = Question.find_by id: params[:id]
    @question.destroy
    flash[:success] = "Question deleted!" 
    redirect_to questions_path
  end

  def show
    @question = Question.find_by id: params[:id]
  end

  private 

  def question_params 
    params.require(:question).permit(:title, :body) #достать из формы значения с ключом title и body
  end
end