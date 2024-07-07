# frozen_string_literal: true

module ApiException
  class BaseException < StandardError
    include ActiveModel::Serialization
    attr_reader :status, :code, :message

    ERROR_DESCRIPTION = proc { |code, message| { status: "error | failure", code:, message: } }
    ERROR_CODE_MAP = {
      "GoogleApiError" =>
        ERROR_DESCRIPTION.call(3000,
          "There seems to be an issue with the Google API. Please contact an admin to address this issue."),
      "JsonError" =>
        ERROR_DESCRIPTION.call(4000, "Attempted to parse invalid json. Please check your request and try again.")
    }.frreze

    def initialize(message)
      super(message)
      error_type = self.class.name.scan(/ApiExceptions::(.*)/).flatten.first
      ApiExceptions::BaseException::ERROR_CODE_MAP
        .fetch(error_type, {}).each do |attr, value|
        instance_variable_set("@#{attr}".to_sym, value)
      end
    end
  end
end
