class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:show]
  before_action :authenticate_user!, only: [:new, :index]

  def index
    @prototype = Prototype.all
    @prototypes = @prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    
    @prototype = Prototype.create(prototype_params)
    @prototype.save
    if @prototype.save
      redirect_to root_path
    else
      @prototypes = @prototype.includes(:user)
      render :new
    end
    
  end

  def edit
    unless user_signed_in?
      @prototype = Prototype.find(params[:id])
      redirect_to action: :index
    end
  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
    @prototype = Prototype.find(params[:id])
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    return redirect_to root_path

  end

  private

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
end


