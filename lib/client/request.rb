module Client
  class Request
    CONNECTION = Faraday
    private_constant :CONNECTION

    def self.connection(url, params = {}, headers = {})
      new(url, params, headers)
    end

    def self.get(url, params = nil, headers = nil)
      connection.get(url, params, headers)
    end

    attr_reader :connection
    private :connection

    private def initialize(url, params, headers)
      @connection = CONNECTION.new(url, params:, headers:)
    end
  end
end
