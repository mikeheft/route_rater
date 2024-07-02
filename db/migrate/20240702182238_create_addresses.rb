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
      t.string :place_id, null: true, index: true
      t.references :owner, polymorphic: true, null: false, index: true

      t.timestamps
    end
    add_index :addresses, %i[city state]
  end
end
