# frozen_string_literal: true

module ApiException
  module ErrorMapper
    def map_error(exception)
      custom_error_class_name = "ApiException::#{exception.class.name.split('::').last}"
      if Object.const_defined?(custom_error_class_name)
        custom_error_class_name.constantize
      else
        define_error_class(custom_error_class_name)
      end
    end

    private def define_error_class(class_name)
      clean_class_name = class_name.split("::").last.gsub(/[^\w]/, "") # Clean up class name

      # Define the error class if it doesn't exist
      unless Object.const_defined?(clean_class_name)
        error_class = Class.new(ApiException::BaseException) do
          def initialize(msg = nil, code = 500, status = :internal_error)
            super(msg, code, status)
          end
        end

        ApiException.const_set(clean_class_name, error_class)
      end

      ApiException.const_get(clean_class_name)
    end
  end
end
