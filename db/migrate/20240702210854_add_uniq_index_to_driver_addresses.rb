# frozen_string_literal: true

class AddUniqIndexToDriverAddresses < ActiveRecord::Migration[7.1]
  def change
    add_index :driver_addresses, %i[current driver_id], unique: true, where: "(current IS TRUE)"
  end
end
