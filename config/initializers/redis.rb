require './lib/cache/store'
redis_url = ENV["REDIS_URL"] || "redis://localhost:6379/1"
::Cache::Store.cache(Redis.new(url: redis_url))