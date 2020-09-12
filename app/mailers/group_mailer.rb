class GroupMailer < ApplicationMailer
  def names_drawn(group, user)
    @group = group
    @user  = user

    mail to: user.email, subject: "Names have been drawn for #{group.name}!"
  end

  def ready_to_draw(group, user)
    @group = group
    @user  = user

    mail to: user.email, subject: "We're ready to draw names for #{group.name}!"
  end

  def invited_to_group(group, user)
    @group = group
    @user  = user

    mail to: user.email, subject: "You've been invited to join '#{group.name}' on Drumroll!"
  end
end
