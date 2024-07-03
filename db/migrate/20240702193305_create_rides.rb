class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.float :duration, index: true
      t.float :distance, index: true
      t.float :commute_duration, index: true
      t.monetize :amount
      t.references :driver, null: true, index: true
      t.references :from_address, foreign_key: {to_table: :addresses}, index: true, null: false
      t.references :to_address, foreign_key: {to_table: :addresses}, index: true, null: false
      t.timestamps
    end
  end
end
