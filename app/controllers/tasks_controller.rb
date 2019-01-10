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
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Task が正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task が登録されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  private

  #まとめる
  def set_task
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to root_url if !@task
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
