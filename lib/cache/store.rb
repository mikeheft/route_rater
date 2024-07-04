# frozen_string_literal: true

module Cache
  class Store
    def self.cache(store)
      @cache ||= store
    end

    def self.set(key, value, expires_in: 1.hour)
      @cache.set(key, value)
      @cache.expire(key, expires_in)
    end

    def self.get(key)
      @cache.get(key)
    end

    def self.del(key)
      @cache.del(key)
    end

    def self.exists?(key)
      @cache.exists(key)&.positive?
    end
  end
end
