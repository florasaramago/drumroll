class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.references :group, null: false
      t.references :user, null: false
      t.boolean :confirmed, default: false
      t.boolean :admin, default: false
      t.text :wishlist
    end

    add_index :memberships, [ :group_id, :user_id ], unique: true
  end
end
