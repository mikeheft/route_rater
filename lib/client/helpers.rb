# frozen_string_literal: true

module Client
  module Helpers
    def with_retries(max_retries: 10, &blk)
      raise NoBlockGiven, "Must provide a block" if blk.blank?

      retries = 0
      begin
        yield
      rescue StandardError => _e
        raise RequestError unless retries <= max_retries

        retries += 1
        max_sleep_seconds = Float(2**retries)
        sleep rand(0..max_sleep_seconds)
        retry
      end
    end
  end
end
