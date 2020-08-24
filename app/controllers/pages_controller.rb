class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    redirect_to groups_url if user_signed_in?
  end

  def about
  end
end
