class MembershipsController < ApplicationController
  before_action :set_group
  before_action :set_membership, only: %i[ show edit update destroy ]

  def new
  end

  def create
    invited_email_addresses.each do |email_address|
      # invite user and create membership
    end

    redirect_to @group
  end

  def show
  end

  def edit
  end

  def update
    @membership.update! membership_update_params
    redirect_to @group
  end

  def destroy
    @membership.destroy!
    redirect_to root_path
  end

  private
    def set_group
      @group = current_user.groups.find params[:group_id]
    end

    def set_membership
      @membership = @group.memberships.find params[:id]
    end

    def invited_email_addresses
      params.require(:membership).permit(:email_addresses)
    end

    def membership_update_params
      params.require(:membership).permit(:confirmed, :wishlist)
    end
end
