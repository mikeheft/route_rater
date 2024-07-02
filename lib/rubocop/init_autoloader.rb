# frozen_string_literal: true

# Load all Ruby files in the custom directory
Dir[File.join(__dir__, "**/*.rb")].each { |file| require file }
