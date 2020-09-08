class RemoveWishlistFromMemberships < ActiveRecord::Migration[6.0]
  def change
    remove_column :memberships, :wishlist
  end
end
