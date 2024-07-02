# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  self.primary_key = :token

  ASCII_LOWER = Array("a".."z").freeze
  ASCII_UPPER = Array("A".."Z").freeze
  DIGITS = Array("0".."9").freeze
  ASCII_LETTERS = [ASCII_LOWER + ASCII_UPPER].sort_by(&:ord).freeze
  ASCII_ALNUM = [ASCII_LETTERS + DIGITS].sort_by(&:ord).freeze
  private_constant :ASCII_LOWER, :ASCII_UPPER, :DIGITS, :ASCII_LETTERS, :ASCII_ALNUM

  before_save :generate_token

  private def generate_token
    return if token.present?

    klass_name = self.class.name
    prefix = klass_name.split("::")&.last&.[](0..2)&.downcase
    at = Time.stamp
    # Jan 1, 2024
    from = 1704070800 # rubocop:disable Style/NumericLiterals
    delta = (at - from) * 1.0

    letters = []
    time_char_length = ASCII_ALNUM.length
    length.times do
      letters << ASCII_ALNUM[delta % time_char_length]
      delta /= time_char_length
    end

    suffix = letters.reverse.join

    "#{prefix}_#{suffix}"
  end
end
