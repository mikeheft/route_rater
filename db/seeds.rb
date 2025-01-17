ADDRESSES = [{:line_1=>"1221 E Elizabeth St", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80524", :line_2=>nil},
 {:line_1=>"2121 E Harmony Rd # 180", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80528", :line_2=>nil},
 {:line_1=>"2315 E Harmony Rd Suite 110", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80528", :line_2=>nil},
 {:line_1=>"608 E Harmony Rd #101", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80525", :line_2=>nil},
 {:line_1=>"1106 E Prospect Rd", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80525", :line_2=>nil},
 {:line_1=>"1939 Wilmington Dr", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80528", :line_2=>nil},
 {:line_1=>"1107 S Lemay Ave", :line_2=>"Suite 240", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80524"},
 {:line_1=>"1024 S Lemay Ave", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80524", :line_2=>nil},
 {:line_1=>"4601 Corbett Dr", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80528", :line_2=>nil},
 {:line_1=>"1113 W Plum St", :line_2=>"Apt 201 D", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80512"},
 {:line_1=>"3397 Wagon Trail Rd", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80524", :line_2=>nil},
 {:line_1=>"5700 N Highway 1", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80524", :line_2=>nil},
 {:line_1=>"6609 Desert Willow Way", :line_2=>"Unit 1", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80525"},
 {:line_1=>"2002 Battlecreek Dr", :line_2=>"Apt 6303", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80528"},
 {:line_1=>"1901 Yorktown Ave", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80526", :line_2=>nil},
 {:line_1=>"3024 Sumac St", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80526", :line_2=>nil},
 {:line_1=>"700 E Drake Rd", :line_2=>"Apt P08", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80525"},
 {:line_1=>"333 Riva Ridge Dr", :line_2=>"Apt C201", :city=>"Fort Collins", :state=>"Co", :zip_code=>"80526"}].freeze

def create_address(**attrs)
  Address.find_or_create_by(**attrs)
end


# Create Drivers
ActiveRecord::Base.connection.transaction do
    puts "Creating Drivers..."
    3.times do |i|
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      driver = Driver.build(first_name:,last_name:)
      attrs = ADDRESSES[i]
      address = create_address(**attrs)
      driver.driver_addresses.build(address_id: address.id, current: true)
      driver.save!
    end

    puts "Creating remaining Addresses..."
    ADDRESSES[(Address.count + 1)..].each do |attrs|
      create_address(**attrs)
    end

    puts "Creating Rides..."
    Address.find_each do |from_address|
      to_address = Address.where.not(id: from_address.id).order("RANDOM()").limit(1).first
      Ride.create!(from_address:, to_address:)
    end
end
