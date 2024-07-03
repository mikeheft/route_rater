module Client
  class Request
    CONNECTION = Faraday
    private_constant :CONNECTION

    def self.connection(url:, params: {}, headers: {})
      new(url, params, headers)
    end

    def post(url, body, headers = nil)
      connection.post(url, body.to_json, headers)
    end

    attr_reader :connection
    private :connection

    private def initialize(url, params, headers)
      @connection = CONNECTION.new(url, params:, headers:)
    end
  end
end
