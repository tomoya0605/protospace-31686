class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:show]
  before_action :move_to_index, except: [:index, :show, :edit]


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
      # @prototypes = @prototype.includes(:user)
      render :new
    end
    
  end

  def edit
     @prototype = Prototype.find(params[:id])
      unless user_signed_in? && current_user.id == @prototype.user_id
        redirect_to new_user_session_path
      end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def show
    user = User.find(params[:id])
    @name = user.name
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

  def move_to_index
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end


