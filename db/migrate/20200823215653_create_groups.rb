class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :names_drawn, default: false
    end
  end
end
