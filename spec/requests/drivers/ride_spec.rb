# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Drivers::Rides", type: :request do
  describe "GET /drivers/:driver_id/rides" do
    it "returns ranked rides" do
      VCR.use_cassette("ranked_rides") do
        attrs = [
          { line_1: "1221 E Elizabeth St", line_2: nil, city: "Fort Collins", state: "CO", zip_code: "80524",
            latitude: 40.5740149, longitude: -105.0551343, place_id: "ChIJK-pLGN5KaYcR3uWeXBYE6ts", id: nil },
          { line_1: "2121 E Harmony Rd # 180", line_2: nil, city: "Fort Collins", state: "CO", zip_code: "80528",
            latitude: 40.5221078, longitude: -105.0368968, place_id: "ChIJS_rwErJMaYcRp8Q9z60tJjQ", id: nil },
          { line_1: "1024 S Lemay Ave", line_2: nil, city: "Fort Collins", state: "CO", zip_code: "80524",
            latitude: 40.5716484, longitude: -105.0566547, place_id: "ChIJRbgIZeBKaYcRRG_TIgGYoIw", id: nil },
          { line_1: "1106 E Prospect Rd", line_2: nil, city: "Fort Collins", state: "CO", zip_code: "80525",
            latitude: 40.5677337, longitude: -105.0574767, place_id: "ChIJ4U-oox9LaYcRrCvlPHIAuKI", id: nil },
          { line_1: "1939 Wilmington Dr", line_2: nil, city: "Fort Collins", state: "CO", zip_code: "80528",
            latitude: 40.5195298, longitude: -105.0420545, place_id: "ChIJvWJU9rBMaYcRtZ5wHymbrUU", id: nil },
          { line_1: "1107 S Lemay Ave", line_2: "Suite 240", city: "Fort Collins", state: "CO", zip_code: "80524",
            latitude: 40.5720018, longitude: -105.0584233, place_id: "ChIJ2QtPVOBKaYcR33T96L5lGSA", id: nil },
          { line_1: "4601 Corbett Dr", line_2: nil, city: "Fort Collins", state: "CO", zip_code: "80528",
            latitude: 40.5220128, longitude: -105.0284598, place_id: "ChIJWxLXuU2zbocRgJWHLDl5uNU", id: nil }
        ]
        addresses = attrs.map { create(:address, **_1) }
        driver = create(:driver, current_address: addresses[0])
        addresses.each do |from_address|
          to_address = Address.where.not(id: [from_address.id,
                                              driver.current_address_id]).order("RANDOM()").limit(1).first
          create(:ride, from_address:, to_address:)
        end

        get "/drivers/#{driver.id}/rides"
        expect(response.status).to eq(200)

        result = JSON.parse(response.body, symbolize_names: true)
        data = result.dig(:data, 0)

        expected_keys = %i[distance duration commute_duration ride_earnings]
        attributes = data[:attributes]
        expect(attributes[:ride_earnings]).to eq("$12.00")
        expect(attributes[:duration].end_with?("minutes")).to be_truthy
        actual_keys = attributes.keys
        expect(expected_keys).to eq(actual_keys)

        expected_relationships = %i[from_address to_address]
        actual_relationships = data[:relationships].keys
        expect(expected_relationships).to eq(actual_relationships)

        included = result[:included]
        expect(included.count).to eq(4)
        expect(included.all? { _1[:type] == "address" }).to be_truthy
      end
    end
  end
end
