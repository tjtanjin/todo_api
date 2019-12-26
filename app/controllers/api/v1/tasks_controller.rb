class Api::V1::TasksController < ApplicationController
  before_action :find_task, only: [:show, :update, :destroy]
  before_action :authorize, only: [:index, :create]
  before_action :authorize_task, only: [:update, :show, :destroy]  

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
    else 
      render json: { error: @task.errors.full_messages[0] }, status: 400
    end
  end

  # Update Task
  def update
    if @task
      if @task.update(task_params)
        render json: { message: 'Task successfully updated!' }, status: 200
      else 
        render json: { error: @task.errors.full_messages[0] }, status: 400
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
    params.require(:task).permit(:task_name, :task_description, :category, :priority, :deadline, :user_id)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def authorize
    return head(:unauthorized) unless current_user && current_user.can_modify_user?(params[:user_id])
  end

  def authorize_task
    return head(:unauthorized) unless current_user && current_user.can_modify_user?(@task.user_id)
  end

end
