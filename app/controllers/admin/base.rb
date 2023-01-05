class Admin::Base < ApplicationController
  layout 'admin'

  private

  def current_admin
    if session[:admin_id]
      @current_admin ||= Admin.find_by(id: session[:admin_id])
    end
  end

  helper_method :current_admin
end
