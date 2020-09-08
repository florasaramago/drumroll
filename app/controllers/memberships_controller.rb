class MembershipsController < ApplicationController
  before_action :set_group
  before_action :check_admin, only: :index
  before_action :check_names_drawn, only: %i[ index new create destroy ]
  before_action :set_membership, only: %i[ show edit update destroy ]

  def index
    @memberships = @group.memberships
  end

  def new
    @invitable_contacts = current_user.invitable_contacts_for(@group)
  end

  def create
    @group.invite email_address_params
    redirect_to @group, notice: "Invitations sent."
  end

  def show
  end

  def edit
  end

  def update
    @membership.update! membership_params
    redirect_to group_membership_url(@group, @membership), notice: "Wishlist saved."
  end

  def destroy
    @membership.destroy!
    redirect_back fallback_location: root_path, notice: "You have left '#{@group.name}'"
  end

  private
    def set_group
      @group = current_user.groups.find params[:group_id]
    end

    def set_membership
      @membership = @group.memberships.find params[:id]
    end

    def check_names_drawn
      if @group.names_drawn?
        redirect_back fallback_location: group_path(@group), alert: "You can't make changes to group members after names have been drawn."
      end
    end

    def check_admin
      unless current_user.admin?(@group)
        redirect_back fallback_location: group_path(@group), alert: "Only admins can edit the group."
      end
    end

    def email_address_params
      params.permit(:email_addresses, contact_email_addresses: {})
    end

    def membership_params
      params.require(:membership).permit(:confirmed, :wishlist, :admin)
    end
end
