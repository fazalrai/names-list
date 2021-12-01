class ApplicationController < ActionController::Base
    include ExceptionHandler

    before_action :authenticate_user!
end
