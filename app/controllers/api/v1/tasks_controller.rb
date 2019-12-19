class Api::V1::TasksController < ApplicationController
  before_action :find_task, only: [:show, :update, :destroy]
  before_action :authorize, only: [:update, :index, :show, :create, :destroy]  

  # Get All Tasks
  def index
    @tasks = User.find(params[:user_id]).task
    render json: @tasks
  end

  # Get Specific Task
  def show
    render json: @task
  end

  # Create Task
  def create
    @task = Task.new(task_params)
    if @task.save
      render json: @task
    elsif @task.errors.added? :job_name, :blank
      render json: { error: "Task name cannot be blank!"}, status: 400
    elsif @task.errors.added? :job_name, "has already been taken"
      render json: { error: "Task already exist!"}, status: 400
    elsif @task.errors.added? :job_desc, :blank
      render json: { error: "Task description cannot be blank!"}, status: 400
    elsif @task.errors.added? :category, :blank
      render json: { error: "Category cannot be blank!"}, status: 400
    else 
      render json: { error: 'An unexpected error has occurred. Please contact an administrator.' }, status: 400
    end
  end

  # Update Task
  def update
    if @task
      if @task.update(task_params)
        render json: { message: 'Task successfully updated!' }, status: 200
      elsif @task.errors.added? :job_name, :blank
        render json: { error: "Task name cannot be blank!"}, status: 400
      elsif @task.errors.added? :job_name, "has already been taken"
        render json: { error: "Task already exist!"}, status: 400
      elsif @task.errors.added? :job_desc, :blank
        render json: { error: "Task description cannot be blank!"}, status: 400
      elsif @task.errors.added? :category, :blank
        render json: { error: "Category cannot be blank!"}, status: 400
      else 
        render json: { error: 'An unexpected error has occurred. Please contact an administrator.' }, status: 400
      end
    else
      render json: { error: 'Task not found.' }, status: 404
    end
  end

  # Delete Task
  def destroy
    if @task
      @task.destroy
      render json: { message: 'Task successfully deleted.' }, status: 200
    else
      render json: { error: 'Unable to delete task.' }, status: 400
    end
  end

  private

  def task_params
    params.require(:task).permit(:job_name, :job_desc, :category, :tag, :due, :user_id)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def authorize
    return head(:unauthorized) unless current_user && current_user.can_modify_user?(@task.user_id)
  end

end
