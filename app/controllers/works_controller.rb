class WorksController < ApplicationController
  before_action :find_work, only: [:show, :edit, :update, :destroy]
  before_action :if_work_missing, only: [:show, :edit, :update, :destroy]
  def index
    @works = Work.all
  end

  def show ; end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      flash[:success] = "Media added successfully!"
      redirect_to work_path(@work.id)
      return
    else
      flash.now[:failure] = "Media failed to save!"
      render :new
      return
    end
  end

  def edit ; end

  def update
    if @work.update(work_params)
      flash[:success] = "Media edited successfully!"
      redirect_to work_path(@work.id)
    else
      flash.now[:failure] = "Media failed to update!"
      render :edit
      return
    end
  end

  def destroy
    if @work.destroy
      flash[:success] = "Work successfully deleted!"
      redirect_to works_path
      return
    end
  end

  def upvote
    if session[:user_id] == nil
      flash[:error] = "Sorry, you must be logged in to vote!"
      redirect_to works_path
      return
    end
    work = Work.find(params[:id])
    if work.votes.find_by(user_id: session[:user_id])
      flash[:error] = "Sorry, you may only vote once for this work!"
      redirect_to works_path
    else
      vote = Vote.create(date: Date.today)
      user = User.find(session[:user_id])
      work.votes << vote
      user.votes << vote
      flash[:success] = "Vote logged!"
      redirect_to work_path
      return
    end
  end

  private
  def work_params
    return params.require(:work).permit(:title, :creator, :category, :release_date, :description)
  end

  def find_work
    @work = Work.find_by(id: params[:id])
  end

  def if_work_missing
    if @work.nil?
      flash[:error] = "Work with id #{params[:id]} was not found!"
      redirect_to works_path
      return
    end
  end
end
