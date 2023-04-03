class AnswersController < ApplicationController

  before_action :set_question! #если не писать only то метод будет поставлен для всех
  before_action :set_answer!, except: :create #порядок важен! ,выполняется для всех случаев кроме create

  def create # создаем метод для класса answer чтобы создавать ответы  
    #render plain: params #посмотреть подробнее параметры   
    @answer = @question.answers.build answer_params
    
    if @answer.save
      flash[:success] = "Answer created"
      redirect_to questions_path(@question)
    else
      @answers = @question.answers.order created_at: :desc #метод order отсортировывает по created_at(полу в бд) и desc это сортировка по убыванию
      render 'questions/show'
    end
  end

  def destroy

    @answer.destroy # удаляем его
    flash[:success] = 'Answer deleted!' # сообщение об удалении
    redirect_to questions_path(@question) # после перенаправляем на страницу вопроса
  end

  def edit #для edit необходим метод update

  end

  def update
    if @answer.update answer_params
      flash[:success] = "answer updated!" 
      redirect_to questions_path(@question)
    else
      render :edit
    end
  end
  
  private

  def answer_params 
    params.require(:answer).permit(:body) #достать из формы :answer значения с ключом body
  end

  def set_question!
    @question = Question.find params[:question_id] #ищет вопрос по парметру question_id с таким id у элемента класса question
  end

  def set_answer!
    @answer = @question.answers.find params[:id] #ищем ответ совпадающий по id
  end
end