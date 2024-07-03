module Client
  class Request
    CONNECTION = Faraday.freeze
    private_constant :CONNECTION

    def self.connection(url, params = {}, headers = {})
      new(url, params, headers)
    end

    def self.post(url, body = nil, headers = nil)
      connection.post(url, body.to_json, headers)
    end

    attr_reader :connection
    private :connection

    private def initialize(url, params, headers)
      @connection = CONNECTION.new(url, params:, headers:)
    end
  end
end
