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
      ApiException.module_eval <<~RUBY, __FILE__, __LINE__ + 1
        class #{class_name.split('::').last} < ApiException::BaseException
          def initialize(msg = nil, code = nil, status = nil)
            super(msg, code, status)
          end
        end
      RUBY

      class_name.constantize
    end
  end
end
