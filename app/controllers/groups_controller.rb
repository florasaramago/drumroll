class GroupsController < ApplicationController
  before_action :set_group, only: %i[ show edit update destroy ]
  before_action :check_admin, only: %i[ edit update destroy ]

  def index
    @groups = current_user.groups
  end

  def new
  end

  def show
    @membership = current_user.membership(@group)
    @exchange   = @group.receiver_for(current_user)
  end

  def create
    group = current_user.groups.create! group_params.merge(creator: current_user)
    redirect_to group
  end

  def edit
  end

  def update
    @group.update! group_params
    redirect_to @group, notice: "Group successfully updated."
  end

  def destroy
    @group.destroy!
    redirect_to groups_url, notice: "Group successfully destroyed."
  end

  private
    def set_group
      @group = current_user.groups.find params[:id]
    end

    def check_admin
      redirect_to @group, alert: "Only admins can edit the group." unless current_user.admin?(@group)
    end

    def group_params
      params.require(:group).permit(:name, :description)
    end
end
