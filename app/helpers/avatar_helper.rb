module AvatarHelper
  def display_avatar(user)
    if user.avatar.attached?
      tag.img src: url_for(user.avatar), class: "avatar"
    else
      tag.img src: image_url("placeholder.png"), class: "avatar"
    end
  end
end
