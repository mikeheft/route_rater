class CreateDriverAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :driver_addresses do |t|
      t.boolean :current, null: false, default: false
      t.references :driver, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
