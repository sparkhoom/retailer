#encoding: utf-8
class UsersController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  def welcome
  end

  def signup
    @user = User.new
  end

  def login
  end

  def create_login_session
    user = User.find_by_name(login_params[:name])
    respond_to do |format|
      if user && user.authenticate(params[:password])
        format.html{
          cookies.permanent[:token] = user.token
          redirect_to root_url, :notice => "登录成功"
        }
        format.json{ render json:user}
      else
        format.html{
          flash[:error] = "无效的用户名和密码"
          redirect_to :login
        }
        format.json { render json:user.errors}
      end
    end
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url, :notice => "已经退出登录"
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html {
          cookies.permanent[:token] = @user.token
          redirect_to :root, :notice => "注册成功"
        }
        format.json { render status: 200}
      else
        format.html {render :signup }
        format.json {render json: @user.errors }
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :phone_number, :email)
  end

  def login_params
    params.permit(:name, :password)
  end
end