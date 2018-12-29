class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
    
  def index
    #メンタリング時の参考レコード
    #@tasks = Task.all.page(params[:page]).per(3)
    @tasks = current_user.tasks.page(params[:page]).per(3)
    #@tasks = Task.where(user_id: session[:user_id])
    #@tasks = Task.where(id:session[:user_id])page(params[:page]).per(3)
    #@tasks = Task.joins(:user).includes(:user)
  end

  def show
    set_task
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'Task が正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が登録されませんでした'
      render :new
    end
  end

  def edit
    set_task
  end

  def update
    set_task
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    set_task
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  private

  #まとめる
  def set_task
    @task = Task.find(params[:id])
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status).merge(user_id: current_user.id)
  end
    
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
end
