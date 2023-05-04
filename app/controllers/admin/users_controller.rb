class Admin::UsersController < ApplicationController # директория пространства имён admin
  before_action :require_authentication

  def index
    @pagy, @users = pagy User.order(created_at: :desc)
  end
end