# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Errors", :skip_geocode, type: :request do
  it "raises JSONParserError and responds with correct error shape" do
    expect(Rides::Commands::GetRoutesData).to receive(:call).and_raise(
      ApiException::JSONParserError.new("Attemped to parse invalid JSON:"), 500
    )
    driver = create(:driver)
    get "/drivers/#{driver.id}/selectable_rides"

    expect(response).to have_http_status(500)
    result = JSON.parse(response.body, symbolize_names: true)

    expect(result[:error].keys).to include(:status, :code, :message)
    expect(result.dig(:error, :message)).to eq("Attemped to parse invalid JSON:")
    expect(result.dig(:error, :code)).to eq("internal_error")
  end
end
