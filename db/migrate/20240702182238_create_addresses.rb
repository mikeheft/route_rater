# frozen_string_literal: true

class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses, id: false, primary_key: :token do |t|
      t.string :token, null: false
      t.string :line_1
      t.string :line_2
      t.string :city
      t.string :state, index: true
      t.string :zip_code, index: true
      t.float :latitude
      t.float :longitude
      t.string :place_id, null: true, index: true
      t.references :owner, polymorphic: true, null: false

      t.timestamps

      t.index :token, unique: true
    end

    add_index :addresses, %i[city state]
  end
end
