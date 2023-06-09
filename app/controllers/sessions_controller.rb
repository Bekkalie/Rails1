# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :require_no_authentication, only: %i[new create]
  before_action :require_authentication, only: %i[destroy]

  def new; end

  # для входа в учетную запись
  def create
    user = User.find_by email: params[:email] # будем искать пользователя по почте
    if user&.authenticate(params[:password])
      # метод authenticate принимает строку и отпраялет ее в бд сверится
      # амперсант это для того чтобы когда метод возвращал nil мы шли дальше в else
      do_sign_in user
    else
      flash.now[:warning] = 'incorrect email and/or password'
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = 'See you later!'
    redirect_to root_path
  end

  private

  def do_sign_in(user)
    sign_in user
    remember(user) if params[:remember_me] == '1' # запоминать пользователя только если он того хочет
    flash[:success] = "Welcome back #{current_user.name_or_email}!"
    redirect_to root_path
  end
end
