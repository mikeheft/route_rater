# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Drivers::Rides", type: :request do
  describe "GET /drivers/:driver_id/rides" do
    it "returns ranked rides" do
      VCR.use_cassette("ranked_rides") do
        drivers = create_list(:driver, 10)
        get "/drivers/#{drivers.first.id}/rides"
        expect(response.status).to eq(200)
      end
    end
  end
end
