module Group::Invitable
  def invite(email_addresses)
    parse(email_addresses).each do |email_address|
      memberships.create! user: find_or_invite_user(email_address)
    end
  end

  private
    def find_or_invite_user(email_address)
      User.find_by(email: email_address) || User.invite!(email: email_address)
    end

    def parse(email_addresses)
      email_addresses.split(',').map { |email| email.split(' ') }.flatten.uniq
    end
end
