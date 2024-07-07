class ApiExceptionSerializer
  include JSONAPI::Serializer
  set_type :error
  set_id do |error, _params|
    error.status
  end

  attributes :status, :code, :message
end
