# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :line_1, null: false
      t.string :line_2, null: true
      t.string :city, null: false
      t.string :state, index: true, null: false
      t.string :zip_code, index: true, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :place_id, null: false

      t.timestamps
    end
    add_index :addresses, %i[city state]
    add_index :addresses, %i[line_1 line_2 zip_code], unique: true
    add_index :addresses, :place_id, unique: true
  end
end
