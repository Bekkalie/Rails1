# frozen_string_literal: true

class QuestionsController < ApplicationController
  # контроллер взаимодействует с файлом views/index.html передавая ему какую либо информацию или методы

  # before_action это часть кода которая будет обьявлена в указаных методах их может быть несколько
  # то есть метод set_question будет выполнен в начале каждого каждого указаного метода в нашем случае
  # это show destroy edit update
  before_action :set_question, only: %i[show destroy edit update]

  def index
    @pagy, @questions = pagy Question.order(created_at: :desc)
    # альтернатива kaminari, две переменные потому что вернет массив состояший из двух элементов
    # дальше pagy и объект который хотим разбивать по страницам

    # Question.order(created_at: :desc).page params[:page]
    # метод order отсортировывает по created_at(полу в бд) и desc это сортировка по убыванию,
    # начиная с .page это идут настройки решения kaminari
    @questions = @questions.decorate
    @current_user = current_user.decorate
  end

  def show
    @question = @question.decorate
    # @question = Question.find_by id: params[:id]
    @answer = @question.answers.build # привязываем question И answer
    @pagy, @answers = pagy @question.answers.order(created_at: :desc)
    # @answers = @question.answers.order(created_at: :desc).page(params[:page])
    # метод order отсортировывает по created_at(полу в бд) и desc это сортировка по убыванию,
    # начиная с .page это идут настройки решения kaminari
    @answers = @answers.decorate
  end

  def new
    @question = Question.new
  end

  def edit
    # @question = Question.find_by id: params[:id]
  end

  # в случаях выше программа найдет просто файл с таким же названием и выведет его на экран
  # а в случае create просто выведет на экран данные
  def create
    # render plain: params
    @question = Question.new question_params
    if @question.save
      flash[:success] = 'Question created!'
      # flash это сообщение которое появляется один раз, после перезагрузки пропадает, flash является хэшем ключ то что в скобках, а значение после равно
      redirect_to questions_path
    else
      render :new
    end
  end

  def update
    # @question = Question.find_by id: params[:id]
    if @question.update question_params
      flash[:success] = 'Question updated!'
      redirect_to questions_path
    else
      render :edit
    end
  end

  def destroy
    # @question = Question.find_by id: params[:id]
    @question.destroy
    flash[:success] = 'Question deleted!'
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body) # достать из формы значения с ключом title и body
  end

  # этот метод будет обьявлен в методах указаных в before_action
  def set_question
    # @question = Question.find_by id: params[:id]
    @question = Question.find params[:id] # метод find удобнее в случаях если запрощенной записи не существует
  end
end
