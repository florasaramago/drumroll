class ExchangesController < ApplicationController
  before_action :set_group

  def create
    @group.draw_names
    redirect_to @group
  end

  def show
    @exchange = @group.receiver_for current_user
  end

  private
    def set_group
      @group = current_user.groups.find params[:group_id]
    end
end
