ADDRESSES = [
  {line_1:"1221 E Elizabeth St", city: "Fort Collins", state: "CO", zip_code: "80524"},
  {line_1:"2121 E Harmony Rd # 180", city: "Fort Collins", state: "CO", zip_code: "80528"},
  {line_1:"2315 E Harmony Rd Suite 110", city: "Fort Collins", state: "CO", zip_code: "80528"},
  {line_1:"608 E Harmony Rd #101", city: "Fort Collins", state: "CO", zip_code: "80525"},
  {line_1:"1106 E Prospect Rd", city: "Fort Collins", state: "CO", zip_code: "80525"},
  {line_1:"1939 Wilmington Dr", city: "Fort Collins", state: "CO", zip_code: "80528"},
  {line_1:"1107 S Lemay Ave", line_2: "Suite 240", city: "Fort Collins", state: "CO", zip_code: "80524"},
  {line_1:"1024 S Lemay Ave", city: "Fort Collins", state: "CO", zip_code: "80524"},
  {line_1:"4601 Corbett Dr", city: "Fort Collins", state: "CO", zip_code: "80528"},

].freeze

# Create Drivers
ActiveRecord::Base.connection.transaction do
    puts "Creating Drivers..."
    3.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      driver = Driver.build(first_name:,last_name:)
      address = Address.create(ADDRESSES.sample)
      driver.create_current_driver_address(address:, current: true)
      driver.save!
    end

    puts "Creating remaining Addresses..."
    ADDRESSES[(Address.count + 1)..].each do |attrs|
      Address.create(**attrs)
    end

    puts "Creating Rides..."
    Address.find_each do |from_address|
      to_address = Address.where.not(id: from_address.id).order("RANDOM()").limit(1).first
      Ride.create!(from_address:, to_address:)
    end
end
