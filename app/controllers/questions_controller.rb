class QuestionController < ApplicationController
  def index 
    @questions = Question.new
  end
end