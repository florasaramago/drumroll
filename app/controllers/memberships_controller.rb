class MembershipsController < ApplicationController
  before_action :set_group
  before_action :set_membership, only: %i[ show edit update destroy ]

  def new
  end

  def create
    invited_email_addresses.each do |email_address|
      @group.memberships.create! user: find_or_invite_user(email_address)
    end

    redirect_to @group
  end

  def show
  end

  def edit
  end

  def update
    @membership.update! membership_params
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

    def find_or_invite_user(email_address)
      User.find_by(email: email_address) || User.invite!(email: email_address)
    end

    def invited_email_addresses
      email_address_params[:email_addresses].split(',').map { |email| email.split(' ') }.flatten.uniq
    end

    def email_address_params
      params.permit(:email_addresses)
    end

    def membership_params
      params.require(:membership).permit(:confirmed, :wishlist)
    end
end
