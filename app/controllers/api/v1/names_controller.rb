class Api::V1::NamesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_todo_item, only: [:show, :edit, :update, :destroy]

    def index
      @names = current_user.names.by_keywords(params[:keywords])
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
      @name = current_user.names.build(name_params)

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
  
    private
      
      def set_name
        @name = TodoItem.find(params[:id])
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