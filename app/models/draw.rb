class Draw
  attr_accessor :group, :members

  def initialize(group)
    @group   = group
    @members = group.memberships.shuffle
  end

  def perform
    if group.can_draw_names?
      members.each_with_index do |member, index|
        receiver = last_member?(member) ? members.first : members[index + 1]
        create_exchange(member, receiver)
      end
    end
  end

  def create_exchange(giver, receiver)
    @group.exchanges.create! giver: giver, receiver: receiver
  end

  def last_member?(member)
    member == members.last
  end
end
