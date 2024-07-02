class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.float :duration, index: true, null: false
      t.float :distance, index: true, null: false
      t.float :commute_duration, index: true, null: false
      t.monetize :amount
      t.references :driver, null: true, index: true
      t.references :from_address, foreign_key: {to_table: :addresses}, index: true, null: false
      t.references :to_address, foreign_key: {to_table: :addresses}, index: true, null: false
      t.timestamps
    end
  end
end
