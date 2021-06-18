class UsersController < ApplicationController
  before_action :forbid_login_user,{only:[:new, :create, :login_form, :login]}
  before_action :ensure_correct_user,{only:[:edit, :update, :destroy]}

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "不正なアクセスです"
      redirect_to("/")
    end
  end

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find_by(id: params[:id])
    if !@user
      redirect_to("/")
    end
    @posts = Post.all.order(created_at: :desc)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by(id: params[:id])
    if !@user
      redirect_to("/")
    end
  end

  # POST /users or /users.json
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      flash[:notice] = "ユーザー登録が完了しました"
      session[:user_id] = @user.id
      redirect_to("/")
    else
      render("users/new")
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    @user.password = params[:password]

    if @user.save
      flash[:notice] = "ユーザー情報が変更されました"
      redirect_to("/users/#{@user.id}")
    else
      render("/users/edit")
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:notice] = "ユーザーを削除しました"
    redirect_to("/")
  end

  def login_form
  end

  def login
    @user = User.find_by(
      email: params[:email],
    )
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/users/#{@user.id}")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

end
