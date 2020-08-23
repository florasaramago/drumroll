class CreateExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :exchanges do |t|
      t.references :group, null: false
      t.belongs_to :giver
      t.belongs_to :receiver
    end

    add_index :exchanges, [ :giver_id, :receiver_id ], unique: true
  end
end
