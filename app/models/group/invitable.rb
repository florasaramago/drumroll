module Group::Invitable
  def invite(email_address_params)
    parsed(email_address_params).each do |email_address|
      memberships.create! user: find_or_invite_user(email_address)
    end
  end

  private
    def find_or_invite_user(email_address)
      User.find_by(email: email_address) || User.invite!(email: email_address)
    end

    def parsed(email_address_params)
      (email_address_list(email_address_params) | contact_list(email_address_params)).uniq
    end

    def email_address_list(email_address_params)
      email_address_params[:email_addresses].split(',').map { |email| email.split(' ') }.flatten
    end

    def contact_list(email_address_params)
      email_address_params[:contact_email_addresses].to_h.map { |email_address, present| email_address if present.to_i.positive? }.compact
    end
end
