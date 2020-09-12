class Draw
  attr_accessor :group, :members

  def initialize(group)
    @group   = group
    @members = group.memberships.shuffle
  end

  def perform
    if group.can_draw_names?
      Group.transaction do
        draw_names
        update_group_status
        notify_members
      end
    end
  end

  private
    def draw_names
      members.each_with_index do |member, index|
        receiver = last_member?(member) ? members.first : members[index + 1]
        create_exchange(member, receiver)
      end
    end

    def create_exchange(giver, receiver)
      @group.exchanges.create! giver: giver, receiver: receiver
    end

    def update_group_status
      @group.update! names_drawn: true
    end

    def notify_members
      members.each do |member|
        GroupMailer.names_drawn(group, member.user).deliver
      end
    end

    def last_member?(member)
      member == members.last
    end
end
