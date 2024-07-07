# frozen_string_literal: true

# rubocop:disable Lint/RedundantSafeNavigation
class ApplicationController < ActionController::API
  rescue_from ApiException::BaseException, with: :render_error_response

  private def pagination_params
    params.permit(:limit, :offset)
  end
  private def limit
    pagination_params[:limit]&.to_i || 2
  end

  private def offset
    pagination_params[:offset]&.to_i || 0
  end

  private def render_error_response(error)
    render json: error, serializer: ApiExceptionSerializer, status: error.status
  end
end
# rubocop:enable Lint/RedundantSafeNavigation
