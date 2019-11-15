class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def route_404
  end

end
