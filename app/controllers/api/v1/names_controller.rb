class Api::V1::NamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: %i[create show index]


  def index
    @names = @list.names
  end

  def show
    if authorized?
      respond_to do |format|
        format.json { render :show }
      end
    else
      handle_unauthorized
    end
  end

  def create
    byebug
    @name = @list.names.build(name_params)

    if authorized?
      respond_to do |format|
        if @name.save
          format.json { render :show, status: :created, location: api_v1_name_path(@name) }
        else
          format.json { render json: @name.errors, status: :unprocessable_entity }
        end
      end
    else
      handle_unauthorized
    end
  end

  def update
    if authorized?
      respond_to do |format|
        if @name.update(name_params)
          format.json { render :show, status: :ok, location: api_v1_name_path(@name) }
        else
          # TODO: Handle errors
          format.json { render json: @name.errors, status: :unprocessable_entity }
        end
      end
    else
      handle_unauthorized
    end
  end

  def destroy
    if authorized?
      @name.destroy
      respond_to do |format|
        format.json { head :no_content }
      end
    else
      handle_unauthorized
    end
  end

  def set_recent_list(list_id)
    current_user.recent_list.list_id = params[:list_id]
  end

  private

  def set_list
    if params[:uuid]
      @list = List.find_by_uuid(params[:uuid]) 
      set_recent_list(@list.id)
    else
      @list = current_user.recent_list.list
    end
  end

  def authorized?
    @name.user == current_user
  end

  def handle_unauthorized
    unless authorized?
      respond_to do |format|
        format.json { render :unauthorized, status: 401 }
      end
    end
  end

  def name_params
    params.require(:todo_item).permit(:title)
  end
end
