class PagesController < ApplicationController

    before_action :authenticate_user!, only: [:my_names]

    def home
    end
    
    def my_names
    end
end