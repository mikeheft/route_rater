# config/initializers/geocoder.rb
Geocoder.configure(
  # street address geocoding service (default :nominatim)
  lookup: :google,

  # IP address geocoding service (default :ipinfo_io)
  ip_lookup: :maxmind,

  # to use an API key:
  api_key: ENV["GOOGLE_API_KEY"],

  # geocoding service request timeout, in seconds (default 3):
  timeout: 15,

  # set default units to kilometers:
  units: :mi,

  # caching (see Caching section below for details):
  cache: Redis.new,
  cache_options: {
    expiration: 1.day, # Defaults to `nil`
  }
)