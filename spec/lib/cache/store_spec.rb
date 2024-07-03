# frozen_string_literal: true

require "rails_helper"
require Rails.root.join("lib/cache/store")

RSpec.describe Cache::Store do
  describe ".set and .get" do
    it "stores and retrieves data from Redis cache" do
      key = "test_key"
      value = "test_value"

      # Set value in cache
      Cache::Store.set(key, value)

      # Get value from cache
      cached_value = Cache::Store.get(key)

      expect(cached_value).to eq(value)
    end
  end

  describe ".del" do
    it "deletes data from Redis cache" do
      key = "test_key"
      value = "test_value"

      # Set value in cache
      Cache::Store.set(key, value)

      # Delete value from cache
      Cache::Store.del(key)

      # Verify value is deleted
      cached_value = Cache::Store.get(key)

      expect(cached_value).to be_nil
    end
  end
end
