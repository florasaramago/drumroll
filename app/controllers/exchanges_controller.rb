class ExchangesController < ApplicationController
  before_action :set_group

  def create
    # draw names

    redirect_to @group
  end

  def show
    @exchange = @group.exchanges.find_by(giver: current_user.membership(@group))
  end

  private
    def set_group
      @group = current_user.groups.find params[:group_id]
    end
end
