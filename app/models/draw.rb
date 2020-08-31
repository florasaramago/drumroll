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
        # TODO: trigger email letting everyone know that names have been drawn.
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

    def last_member?(member)
      member == members.last
    end
end
