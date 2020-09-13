class MembershipsController < ApplicationController
  before_action :set_group
  before_action :check_admin, only: :index
  before_action :check_names_drawn, only: %i[ index new create destroy ]
  before_action :set_membership, only: %i[ show edit update destroy ]
  before_action :check_authorized_user, only: %i[ update destroy ]

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
    redirect_after_update
  end

  def destroy
    if @membership.user.can_leave?(@group)
      @membership.destroy!

      flash.notice = "You have left '#{@group.name}'" if @membership.user == current_user
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: group_path(@group), alert: "You need to make someone else an admin before you can leave the group."
    end
  end

  private
    def set_group
      @group = current_user.groups.find params[:group_id]
    end

    def set_membership
      @membership = @group.memberships.find params[:id]
    end

    def redirect_after_update
      if @membership.admin_previously_changed?
        redirect_to group_memberships_url(@group), notice: "#{@membership.user.name} is now an admin."
      elsif @membership.confirmed_previously_changed?
        redirect_to group_url(@group), notice: "You have officially joined #{@group.name}."
      else
        redirect_to group_membership_url(@group, @membership), notice: "Wishlist saved."
      end
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

    def check_authorized_user
      unless current_user == @membership.user || current_user.admin?(@group)
        redirect_back fallback_location: group_path(@group), alert: "If you're not an admin, you can only make changes to you own membership."
      end
    end

    def email_address_params
      params.permit(:email_addresses, contact_email_addresses: {})
    end

    def membership_params
      params.require(:membership).permit(:confirmed, :wishlist, :admin)
    end
end
