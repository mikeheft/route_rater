# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state, index: true
      t.string :zip_code, index: true
      t.float :latitude
      t.float :longitude
      t.string :place_id, null: true, index: true
      t.references :owner, polymorphic: true, null: false, index: true

      t.timestamps
    end
    add_index :addresses, %i[city state]
  end
end
