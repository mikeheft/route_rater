# frozen_string_literal: true

module ApiException
  class BaseException < StandardError
    include ActiveModel::Serialization
    attr_reader :status, :code, :message

    def initialize(message, code = 500, status = "error")
      super(message)
      @status = status
      @code = code
      @message = message
    end
  end

  class HTTPRequestError < BaseException; end
  class JSONParserError < BaseException; end
  class NoBlockGivenError < BaseException; end
  class NotFoundError < BaseException; end
  class RetryError < BaseException; end
  class RideCountMismatchError < BaseException; end
end
