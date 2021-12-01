# frozen_string_literal: true

module Api
  module V1
    class NamesController < ApplicationController
      # before_action :set_list, only: %i[create show index]

      def index
        if params[:uuid]
          update_recently_list(list)
        end

        render json: collection
      end

      def create
        if new_resource.save
          render json: new_resource, status: :created
        else
          render json: { message: new_resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

        def collection
          @collection ||= if params[:q]
                            list.names.search(params[:q])
                          else
                            list.names
                          end
        end

        def new_resource
          @new_resource ||= list.names.new(permitted_params.merge(user_id: current_user.id))
        end

        def list
          @list ||= if params[:uuid].present?
                      List.find_by_uuid!(params[:uuid])
                    else
                      current_user.recent_list.list
                    end
        end

        def update_recently_list(list)
          recent_list = current_user.recent_list
          recent_list.list_id = list.id

          recent_list.save
        end

        def permitted_params
          params.require(:name).permit(:title)
        end
    end
  end
end
