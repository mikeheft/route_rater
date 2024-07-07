# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Drivers", :skip_geocode, type: :request do
  let!(:drivers) { create_list(:driver, 10) }
  describe "GET /index" do
    it "returns list of drivers" do
      get "/drivers?limit=10"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result[:data].count).to eq(10)
      obj = result.dig(:data, 0)
      expect(obj[:type]).to eq("driver")
      expect(obj.dig(:relationships, :current_address, :data, :type)).to eq("address")
    end

    it "can paginate list of drivers" do
      get "/drivers?limit=2&offset=0"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body, symbolize_names: true)
      first_result = result[:data]

      expect(first_result.count).to eq(2)

      get "/drivers?limit=2&offset=2"
      expect(response.status).to eq(200)
      result = JSON.parse(response.body, symbolize_names: true)
      second_result = result[:data]

      expect(first_result.map { _1[:id] }).to_not eq(second_result.map { _1[:id] })
    end
  end
end
