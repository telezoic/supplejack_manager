# frozen_string_literal: true

class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:active] == 'false'
      @users = User.deactivated
    else
      @users = User.active
    end
  end

  def new
  end

  def create
    if can?(:edit_users, current_user) && params.dig(:user, :role)
      # Not permitted parameter via Strong Params
      @user.role = params.dig(:user, :role)
    end

    if @user.save
      redirect_to users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if params.dig(:user, :role)
      authorize! :edit_users, @user
      @user.role = params.dig(:user, :role)
    end

    if needs_password?(@user)
      if @user.update_attributes(user_params)
        bypass_sign_in(@user) if @user == current_user
        redirect_to safe_users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    else
      params[:user].delete(:password)
      @user.update_without_password(user_params)
      redirect_to safe_users_path, notice: 'User was successfully updated.'
    end
  end

  private
    def needs_password?(user)
      user.email != user_params[:email] ||
        user_params[:password].present?
    end

    def user_params
      params
        .require(:user)
        .permit(
          :name, :email, :password, :password_confirmation, :active, :manage_data_sources, :manage_parsers, :manage_harvest_schedules, :manage_link_check_rules,
          manage_partners: [], run_harvest_partners: [])
    end
end
