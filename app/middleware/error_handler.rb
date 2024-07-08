# frozen_string_literal: true

require "./lib/api_exception/error_mapper"

module Middleware
  class ErrorHandler
    include ApiException::ErrorMapper # Include the module where map_error and define_error_class are defined

    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    rescue StandardError => e
      handle_exception(e)
    end

    private def handle_exception(exception)
      error_class = map_error(exception)
      raise error_class, exception.message
    rescue ApiException::RecordNotFound => e
      render_error_response(e, 404, :not_found)
    rescue StandardError => e
      render_error_response(e, 500, :internal_error)
    end

    private def render_error_response(error, status, code)
      [status, { "Content-Type" => "application/json" },
       [{ error: { status:, code:, message: error.message } }.to_json]]
    end
  end
end
