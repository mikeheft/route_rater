# frozen_string_literal: true

module GeocoderStub
  def stub_geocoder
    allow_any_instance_of(Address).to receive(:geocode)
  end
end
