# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Drivers", :skip_geocode, type: :request do
  let!(:drivers) { create_list(:driver, 10) }
  describe "GET /index" do
    it "returns paginated list of drivers" do
      get "/drivers"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data].count).to eq(10)
      obj = result.dig(:data, 0)
      expect(obj[:type]).to eq("driver")
      expect(obj.dig(:relationships, :current_address, :data, :type)).to eq("address")
    end
  end
end
