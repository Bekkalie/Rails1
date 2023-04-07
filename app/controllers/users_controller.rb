class UsersController < ApplicationController #контроллер создания процесса регистрации
  def new 
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id #строчка кода для того чтобы сохранять пользователя во время сесси
      flash[:success] = "Welcome #{@user.name}!"
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end