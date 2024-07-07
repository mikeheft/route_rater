# frozen_string_literal: true

class AddMaxRadiusToDriver < ActiveRecord::Migration[7.1]
  def change
    add_column :drivers, :max_radius, :integer, default: 10
    add_index :drivers, :max_radius
  end
end
