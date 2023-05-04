# frozen_string_literal: true

class AnswersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_question! # если не писать only то метод будет поставлен для всех
  before_action :set_answer!, except: :create # порядок важен! ,выполняется для всех случаев кроме create

  # для edit необходим метод update
  def edit; end

  # создаем метод для класса answer чтобы создавать ответы
  def create
    # render plain: params #посмотреть подробнее параметры
    @answer = @question.answers.build answer_params

    if @answer.save
      flash[:success] = 'Answer created'
      redirect_to questions_path(@question) #(@question, anchor: dom_id(@answer))
      # теперь после нажатий на Submit при изменении ответа будет перебрасывать по якорю
      # на вопрос к которому относиться ответ по id
    else
      @question = @question.decorate
      @pagy, @answers = pagy @question.answers.order created_at: :desc # метод order отсортировывает по created_at(полу в бд) и desc это сортировка по убыванию
      @answers = @answers.decorate
      render 'questions/show'
    end
  end

  def update
    if @answer.update answer_params
      flash[:success] = 'Answer updated!'
      redirect_to question_path(@question, anchor: dom_id(@answer))
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy # удаляем его
    flash[:success] = 'Answer deleted!' # сообщение об удалении
    redirect_to question_path(@question) # после перенаправляем на страницу вопроса
  end

  private

  def answer_params
    params.require(:answer).permit(:body) # достать из формы :answer значения с ключом body
  end

  def set_question!
    @question = Question.find params[:question_id] # ищет вопрос по парметру question_id с таким id у элемента класса question
  end

  def set_answer!
    @answer = @question.answers.find params[:id] # ищем ответ совпадающий по id
  end
end
