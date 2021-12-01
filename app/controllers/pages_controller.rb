class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:my_names]

  def home
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
